package builder.windows;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import javax.swing.*;
import javax.swing.event.*;
import java.util.Vector;

import builder.*;
import builder.beans.*;
import builder.exceptions.*;
import builder.windows.event.*;

public class BeansWindow extends BuilderWindow {

  private JToolBar toolbar;
  private JScrollPane pane;
  private JList beanList;
  private DeleteBeanAction deleteBean;
  private SelectBeanAction selectBean;
  private Vector beans;
  private Builder builder;

  public BeansWindow( Builder builder ) {

    super( "Beans" );

    this.builder = builder;

    setBounds( 0,0, 200,300 );

    beans = new Vector();
    deleteBean = new DeleteBeanAction();
    selectBean = new SelectBeanAction();

    toolbar = new JToolBar();
    toolbar.setFloatable( false );
    toolbar.setLayout( new FlowLayout( FlowLayout.RIGHT ) );
    toolbar.add( deleteBean );
    toolbar.add( selectBean );
    getContentPane().add( toolbar, BorderLayout.SOUTH );

    setButtonsEnabled( false );
    refreshList();

  }

  /**
   *  Called whenever a change is made to the bean list
   */

  private void refreshList() {
    if (pane != null)
      remove( pane );
    beanList = new JList( beans );
    beanList.setSelectionMode( ListSelectionModel.SINGLE_SELECTION );
    beanList.addListSelectionListener( new ListSelectionListener() {
      public void valueChanged( ListSelectionEvent evt ) {
        setButtonsEnabled( true );
        builder.getEditorWindow().deselectAll();
      }
    });
    pane = new JScrollPane( beanList );
    getContentPane().add( pane, BorderLayout.CENTER );
    show();
  }

  /**
   *  Adds a bean to the bean selection window.  If the bean has already
   *  been loaded then an <i>BeanAlreadyLoadedException</i> is thrown.
   *
   *  @param bean This is the builders representation of a bean, it is
   *  created by the static <i>BeanLoader</i> class.
   *
   */

  public void addBean( LoadedBean bean, String fullName ) throws BeanAlreadyLoadedException {

    //  check bean hasn't already been loaded
    for ( int i=0; i<beans.size(); i++ )
      if ( ((LoadedBean)beans.elementAt(i)).equals(bean) )
        throw new BeanAlreadyLoadedException();

    //  add bean
    beans.addElement( bean );
    setButtonsEnabled( false );
    refreshList();
  }

  /**
   *  Sets the status of the windows buttons
   */

  private void setButtonsEnabled( boolean b ) {
    deleteBean.setEnabled( b );
    selectBean.setEnabled( b );
  }

  /**
   *  This action is fired when the delete bean button is pressed
   */

  class DeleteBeanAction extends BuilderAction {
    public DeleteBeanAction() {
      super( "deletebean.gif" );
    }
    public void actionPerformed( ActionEvent evt ) {
      beans.removeElementAt( beanList.getSelectedIndex() );
      setButtonsEnabled( false );
      refreshList();
    }
  }

  /**
   *  This action is fired when the select bean button is pressed,
   */

  class SelectBeanAction extends BuilderAction {
    public SelectBeanAction() {
      super( "selectbean.gif" );
    }
    public void actionPerformed( ActionEvent evt ) {
      builder.getEditorWindow().arm( (LoadedBean)beans.elementAt(beanList.getSelectedIndex()), EditorWindow.PLACE_BEAN );
    }
  }

}