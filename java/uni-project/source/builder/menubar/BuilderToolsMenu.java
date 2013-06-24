package builder.menubar;

import javax.swing.*;
import java.awt.event.*;
import java.lang.reflect.*;
import java.beans.*;

import builder.*;
import builder.windows.*;
import builder.editors.*;
import builder.beans.*;

public class BuilderToolsMenu extends JMenu {

  private Builder builder;

  public BuilderToolsMenu( Builder builder ) {

    super( "Tools" );

    this.builder = builder;

    add( new RegisterAction() );
    add( new RegisterImageAction() );
    add( new ExportAction() );

  }

  private class RegisterImageAction extends AbstractAction {

    public RegisterImageAction() {
      super( "Register Image" );
    }

    public void actionPerformed( ActionEvent evt ) {

      try {

        String beanClass = BuilderDialogs.input( builder, "Please enter the class to register the image for:" );
        String imgSource = BuilderDialogs.input( builder, "Please enter the source for the image:" );

        BeanImageManager.registerBeanImage( beanClass, imgSource );

        BuilderDialogs.inform( builder, "Image Registered!" );

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error Registering Image" );
      }

    }

  }

  private class ExportAction extends AbstractAction {

    public ExportAction() {
      super( "Export" );
    }

    public void actionPerformed( ActionEvent evt ) {
      ProjectExporter.exportProject( builder );
    }

  }

  private class RegisterAction extends AbstractAction {

    public RegisterAction() {
      super( "Register Editor" );
    }

    public void actionPerformed( ActionEvent evt ) {

      try {

        Class cls1 = Class.forName( BuilderDialogs.input( builder, "Enter class to register handler for:" ) );
        Class cls2 = Class.forName( BuilderDialogs.input( builder, "Enter class of the handler:" ) );

        BuilderEditorManager.registerNewEditor( cls1, cls2 );

        BuilderDialogs.inform( builder, "The handler has been registered." );

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error Registering Handler: " +e );
      }

    }
  }

}