package builder.windows;

import java.beans.*;
import java.lang.reflect.*;
import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;

import builder.*;
import builder.beans.*;

public class PropertyWindow extends BuilderWindow {

  private BuilderBean bean;
  private JTabbedPane tab;
  private JScrollPane pane;
  private Builder builder;

  public PropertyWindow( Builder builder ) {

    super( "PropertySheet" );

    this.builder = builder;

    tab = new JTabbedPane();
    pane = new JScrollPane( tab );

    setSize( 600, 200 );
    setLocation( 200, 300 );
    getContentPane().add( pane );

  }

  /**
   *  Loads a property sheet for the given bean
   */

  public void load( BuilderBean bean ) {

    clear();

    this.bean = bean;

    tab = new JTabbedPane();

    try {

      Class cls = Class.forName( bean.getFullName() );
      BeanInfo bi = Introspector.getBeanInfo( cls );
      PropertyDescriptor pds[] = bi.getPropertyDescriptors();

      for ( int i=0; i<pds.length; i++ ) {
        try {
          PropertyDescriptor pd = pds[i];

          if ( isReadWriteProperty( pd ) ) { // only draw read/writeable properties

            /*
             *  get editor and set appropriate value
             */

            Class propCls = editPropertyType( pd.getPropertyType() );
            PropertyEditor pe = PropertyEditorManager.findEditor( propCls );
            Component cp = pe.getCustomEditor();

            if ( cp != null ) { // if there is a registered editor

              String propName = pd.getDisplayName();
              String temp = "" + propName.charAt(0);
              propName = temp.toUpperCase() + propName.substring(1);

              // set parameter types
              Class partypes[] = new Class[0];
              Object arglist[] = new Object[0];

              // fetch the method, invoke amd set
              Method meth = cls.getMethod( "get" +propName, partypes);
              pe.setValue( meth.invoke(bean.self, arglist) );

              // add property tab
              pe.addPropertyChangeListener( new BeanEditListener( bean, pe, pd ) );
              tab.addTab( pd.getDisplayName(), cp );

            }

          }

        }
        catch( Exception e ) {}
      }

      pane = new JScrollPane( tab );
      getContentPane().add( pane );
      show();

      builder.getInfoWindow().load( bean );

    }
    catch ( Exception e ) {
      BuilderDialogs.error( builder, "Error creating property sheet." );
    }

  }

  /**
   *  changes primitives into their objects
   */

  public Class editPropertyType( Class cls ) {

    String name = cls.toString();

    if ( name.equals("boolean") )
      return java.lang.Boolean.class;

    else if ( name.equals("int") )
      return java.lang.Integer.class;

    return cls;

  }

  /**
   *  clears the property window
   */

  public void clear() {

    if ( pane != null ) remove( pane );

    pane = null;
    bean = null;

    show();

    builder.getInfoWindow().clear();

  }

  /**
   *  Indicates whether or not a property is read/writeable
   */

  public static boolean isReadWriteProperty( PropertyDescriptor pd ) {
    if ( isReadProperty( pd ) && ( pd.getWriteMethod() != null)) return true;
      else return false;
  }

  /**
   *  Indicates whether or not a property is readable
   */

  public static boolean isReadProperty( PropertyDescriptor pd ) {
    if ( pd.getReadMethod() != null ) return true;
      return false;
  }

  /**
   *  local class for handling property changes
   */

  private class BeanEditListener implements PropertyChangeListener {

    private BuilderBean bean;
    private PropertyEditor editor;
    private PropertyDescriptor descriptor;
  
    public BeanEditListener( BuilderBean bean, PropertyEditor editor, PropertyDescriptor descriptor ) {
      this.bean = bean;
      this.editor = editor;
      this.descriptor = descriptor;
    }

    public void propertyChange( PropertyChangeEvent evt ) {

      try {

        // current property name
        String propName = descriptor.getDisplayName();
        String temp = "" + propName.charAt(0);
        propName = temp.toUpperCase() + propName.substring(1);

        // get beans class
        Class cls = Class.forName( bean.getFullName() );

        // set parameter types
        Class partypes[] = new Class[1];
        partypes[0] = descriptor.getPropertyType();

        // fetch the method to be invoked
        Method meth = cls.getMethod( "set" +propName, partypes);

        // assemble parameters
        Object arglist[] = new Object[1];
        arglist[0] = editor.getValue();

        // invoke method on bean
        meth.invoke(bean.self, arglist);

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error Updating Property" );
      }

    }

  }

}