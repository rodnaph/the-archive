package builder.windows;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;
import java.beans.*;
import java.lang.reflect.*;

import builder.*;
import builder.beans.*;
import builder.menubar.*;
import builder.windows.event.*;

public class EditorWindow extends BuilderWindow {

  // arming types
  public static final int PLACE_BEAN = 0;
  public static final int ADD_EVENT = 1;

  private boolean armed; // if editor is armed it is awaiting an event
  private LoadedBean armedBean; // temp store for beans waiting to be placed/attached
  private Vector beans, links;
  private EditorCanvas canvas;
  private Builder builder;
  private int armType;
  private int objID = 0;
  private BuilderBean selectedBean;

  public EditorWindow( Builder builder ) {
    super( "Editor" );

    this.builder = builder;

    setSize(600,300);
    setLocation(200,0);

    beans = new Vector();
    links = new Vector();
    canvas = new EditorCanvas();

    Container c = getContentPane();
    c.add( canvas );

    setBackground( Color.white );
    canvas.addMouseListener( new MouseHandler() );

    show();

    beans = new Vector();
    armed = false;
    selectedBean = null;
    redraw();
  }

  /**
   *  returns the current object id
   */

  public int getID() {
    return objID;
  }

  /**
   *  sets the object id
   */

  public void setID( int objID ) {
    this.objID = objID;
  }

  /**
   *  returns the size of the canvas
   */

  public Dimension getSize() {
    return canvas.getSize();
  }

  /**
   *  returns the beans loaded
   */

  public Vector getBeans() {
    return beans;
  }

  /**
   *  sets the beans
   */

  public void setBeans( Vector beans ) {
    this.beans = beans;
  }

  /**
   *  returns the links
   */

  public Vector getLinks() {
    return links;
  }

  /**
   *  sets the links
   */

  public void setLinks( Vector links ) {
    this.links = links;
  }

  /**
   *  arming the editor
   */

  public void arm( LoadedBean bean, int armType ) {
    this.armedBean = bean;
    this.armType = armType;
    armed = true;
  }

  /**
   *  disarming the editor
   */

  public void disarm() {
    armed = false;
  }

  /**
   *  places a bean at a given point
   */

  public void placeBean( int x, int y, BuilderBean bean ) {

    beans.addElement( bean );
    redraw();

    builder.getProject().addField( bean );

  }

  /**
   *  for redrawing the editor window
   */

  private void redraw() {
    canvas.repaint();
  }

  /**
   *  deselectAll()
   */

  public void deselectAll() {

    for ( int i=0; i<beans.size(); i++ )
      ( (BuilderBean) beans.elementAt(i) ).setSelected(false);

    builder.getPropertyWindow().clear();
    builder.getMenu().setBeanMenu( false );

    redraw();

  }

  /**
   *  tries to show a beans event menu
   */

  private void tryBeanSelect( int x, int y, boolean eventSelect ) {

    deselectAll();

    for ( int i=0; i<beans.size(); i++ ) {
      BuilderBean bean = (BuilderBean) beans.elementAt(i);
      if ( bean.contains(x,y) ) {
        bean.setSelected(true);
        selectedBean = bean;

        if ( eventSelect ) System.out.println( "Events:" );
          else builder.beanSelected( bean );

        break;
      }
    }

    redraw();

  }

  /**
   *  tries to link events
   */

  private void tryEventLink( int x, int y ) {

    boolean linked = false;

    for ( int i=0; i<beans.size(); i++ ) {

      BuilderBean bean = (BuilderBean) beans.elementAt(i);

      if ( bean.contains( x, y ) ) {

        launchEventLinker( bean, x, y );

        // clean up
        disarm();
        armedBean = null;
        linked = true;

      }

    }

    if ( !linked ) {
      BuilderDialogs.error( builder, "Need to select an appropriate bean!" );
    }

  }

  /**
   *  launches dialog for selecting the method to call
   */

  private void launchEventLinker( BuilderBean bean, int x, int y ) {

    try {

      JPopupMenu popup = new JPopupMenu();
      JPanel panel = new JPanel();

      Class cls = Class.forName( bean.getFullName() );
      Method[] allMethods = cls.getMethods();
      Vector methods = new Vector();

      // select appropriate methods
      for ( int i=0; i<allMethods.length; i++ ) {

        Method method = allMethods[i];
        String s = method.getName().substring(0,3);
        String t = s.substring(0,2);
        Class[] partypes = method.getParameterTypes();

        if ( !s.equals("get") && !s.equals("set") && !s.equals("add") && !s.equals("rem")
             && (partypes.length == 0) && !t.equals("is") ) {
          methods.addElement( method );
        }
        
      }

      panel.setLayout( new GridLayout(methods.size(),1) );

      for ( int i=0; i<methods.size(); i++ ) {

        Method method = (Method) methods.elementAt(i);
        JButton linkButton = new JButton( method.getName() );

        linkButton.addActionListener( new LinkEventListener( bean, method, popup ) );
        panel.add( linkButton );

      }

      popup.add( new JScrollPane(panel) );
      popup.setPopupSize( 250, 200 );
      popup.show( this, x, y );

    }
    catch ( Exception e ) {
      BuilderDialogs.error( builder, "Error Creating Handler List" );
    }

  }

  /**
   *  for the final stage of event linking
   */

  private class LinkEventListener implements ActionListener {

    private BuilderBean handlerBean;
    private Method handlerMethod;
    private JPopupMenu dialog;

    public LinkEventListener( BuilderBean handlerBean, Method handlerMethod, JPopupMenu dialog ) {
      this.handlerBean = handlerBean;
      this.handlerMethod = handlerMethod;
      this.dialog = dialog;
    }

    public void actionPerformed( ActionEvent evt ) {

      EventPackage ep = builder.getMenu().getEventPackage();

      builder.getProject().addEventLink( handlerBean, handlerMethod, ep );
      links.addElement( new EventLink( ep.getSource(), handlerBean ) );
      dialog.setVisible( false );

      redraw();

    }

  }

  /**
   *  EditorCanvas class
   */

  private class EditorCanvas extends JPanel {

    public void paintComponent( Graphics g ) {

      // draw event links
      for ( int i=0; i<links.size(); i++ ) {
        EventLink el = (EventLink) links.elementAt(i);
        g.drawLine( el.getFrom().x, el.getFrom().y, el.getTo().x, el.getTo().y );
        g.fillOval( el.getTo().x-4, el.getTo().y-4, 8,8 );
      }

      // draw beans
      for (  int i=0; i<beans.size(); i++ ) {

        BuilderBean bean = (BuilderBean) beans.elementAt(i);
        Color color = ( bean.isSelected() ) ? Color.blue : Color.black;

        g.setColor( color );
        g.drawRect( bean.getPosition().x, bean.getPosition().y,
                    bean.getSize().width, bean.getSize().height );

        g.setColor( Color.black );
        g.drawString( bean.toString(), bean.getPosition().x, bean.getPosition().y );

      }

    }

  }

  /**
   *  handling mouse clicks
   */

  private class MouseHandler extends MouseAdapter {

    public void mousePressed( MouseEvent evt ) {
      if (!armed) tryBeanSelect( evt.getX(), evt.getY(), evt.isPopupTrigger() );
    }

    public void mouseReleased( MouseEvent evt ) {
      if (armed) {

        switch (armType) {
          case PLACE_BEAN : disarm();
                            BuilderBean newBean = new BuilderBean( armedBean.getFullName(), builder, evt.getX(), evt.getY(), objID++ );
                            armedBean = null;
                            break;
          case ADD_EVENT : tryEventLink( evt.getX(), evt.getY() );
                           break;
        }

      }
    }

  }

}