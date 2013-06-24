package builder.menubar;

import java.awt.event.*;
import javax.swing.*;
import java.lang.reflect.*;
import java.beans.*;

import builder.*;
import builder.beans.*;
import builder.windows.*;
import builder.windows.event.*;

public class BuilderMenuBar extends JMenuBar {

  private Builder builder;
  private JMenu beanMenu, eventMenu;
  private AbstractAction importAction;
  private EventPackage eventPackage;

  public BuilderMenuBar( Builder builder ) {

    this.builder = builder;

    beanMenu = new JMenu( "Bean" );
    eventMenu = new JMenu( "Events" );

    importAction = new ImportAction();

    beanMenu.add( importAction );
    beanMenu.add( eventMenu );

    add( new BuilderFileMenu( builder ) );
    add( new BuilderToolsMenu( builder ) );
    add( beanMenu );

    setImportAction( false );
    setBeanMenu( false );

  }

  /**
   *  sets the status of the import action
   */

  public void setImportAction( boolean b ) {
    importAction.setEnabled( b );
  }

  /**
   *  sets the enabled status of the beans menu
   */

  public void setBeanMenu( boolean b ) {
    eventMenu.setEnabled( b );
  }

  /**
   *  returns the current event package
   */

  public EventPackage getEventPackage() {
    return eventPackage;
  }

  /**
   *  loads the event
   */

  public void loadBeanMenu( BuilderBean bean ) {

    JMenu newMenu = new JMenu( "Events" );

    try {

      Class cls = Class.forName( bean.getFullName() );
      BeanInfo bi = Introspector.getBeanInfo( cls );
      EventSetDescriptor es[] = bi.getEventSetDescriptors();

      for ( int i=0; i<es.length; i++ ) {

        EventSetDescriptor event = es[i];
        String eventType = event.getListenerType().toString();
        JMenu menu = new JMenu( eventType.substring( eventType.lastIndexOf('.')+1 ) );

        Class listener = event.getListenerType();
        Method[] methods = listener.getMethods();

        // add method buttons to dialog
        for ( int j=0; j<methods.length; j++ ) {
          menu.add( new AddEventButton( event, bean, methods[j], listener ) );
        }

        newMenu.add( menu );

      }

      beanMenu.remove( eventMenu );
      beanMenu.add( newMenu );
      eventMenu = newMenu;

      setBeanMenu( true ); // finally enable the menu

    }
    catch ( Exception e ) {
      BuilderDialogs.error( builder, "MenuError: " +e );
    }

  }

  /**
   *  class for event adding actions
   */

  private class AddEventButton extends AbstractAction {

    private EventSetDescriptor descriptor;
    private BuilderBean source;
    private Method method;
    private Class listener;

    public AddEventButton( EventSetDescriptor descriptor, BuilderBean source, Method method, Class listener ) {

      super( method.getName() );

      this.descriptor = descriptor;
      this.source = source;
      this.method = method;
      this.listener = listener;

    }    

    public void actionPerformed( ActionEvent evt ) {

      eventPackage = new EventPackage( source, descriptor, method, listener );
      builder.getEditorWindow().arm( null, EditorWindow.ADD_EVENT );

    }

  }

  /**
   *  action for importing beans
   */

  private class ImportAction extends AbstractAction {

    public ImportAction() {
      super( "Import Bean" );
    }

    public void actionPerformed( ActionEvent evt ) {

      String result = BuilderDialogs.input( builder, "Please enter the fully qualified name of the bean to import:  " );

      if ( result != null )
        BeanLoader.importBean( builder, result );

    }

  }

}