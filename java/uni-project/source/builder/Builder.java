package builder;

import java.awt.*;
import javax.swing.*;
import java.util.*;
import java.awt.event.*;
import java.beans.*;
import java.io.*;

import builder.beans.*;
import builder.toolbar.*;
import builder.exceptions.*;
import builder.menubar.*;
import builder.windows.*;
import builder.windows.event.*;
import builder.editors.*;

public class Builder extends JFrame {

  private BuilderSplashScreen splash;
  private JDesktopPane desktop;
  private BuilderToolBar toolbar;
  private BuilderMenuBar menubar;
  private BeansWindow beansWindow;
  private PropertyWindow propertyWindow;
  private EditorWindow editorWindow;
  private InfoWindow infoWindow;
  private BuilderProject currentProject;
  private Vector frames;

  private final boolean SHOW_SPLASH = false;

  /**
   *  The command line interface to the class
   */

  public static void main( String args[] ) {
    Builder builder = new Builder();
    builder.setVisible( true );
  }

  /**
   *  The constructor for the main Builder class
   */

  public Builder() {
    super( "Builder v1.1" );

    if (SHOW_SPLASH) splash = new BuilderSplashScreen(7000);
    if (SHOW_SPLASH) splash.setStatus( "Setting up application window..." );
    setSize(700,500);
    addWindowListener( new WindowAdapter() {
      public void windowClosing( WindowEvent e ) { exitApp(); }
    });

    if (SHOW_SPLASH) splash.setStatus( "Creating builder tools..." );
    currentProject = null;
    menubar = new BuilderMenuBar( this );
    desktop = new JDesktopPane();
    toolbar = new BuilderToolBar( this );

    if (SHOW_SPLASH) splash.setStatus( "Laying out components..." );
    setJMenuBar( menubar );
    getContentPane().add( desktop, BorderLayout.CENTER );
    getContentPane().add( toolbar, BorderLayout.SOUTH );

    if (SHOW_SPLASH) splash.close();

    BuilderEditorManager.loadDefaultEditors();

  }

  /**
   *  getters
   */

  public BeansWindow getBeansWindow() { return beansWindow; }
  public PropertyWindow getPropertyWindow() { return propertyWindow; }
  public EditorWindow getEditorWindow() { return editorWindow; }
  public BuilderProject getProject() { return currentProject; }
  public BuilderMenuBar getMenu() { return menubar; }
  public InfoWindow getInfoWindow() { return infoWindow; }

  /**
   *  Signals a bean has been selected in the bean window,
   *  and the property sheet needs to be drawn.
   */

  public void beanSelected( BuilderBean bean ) {
    propertyWindow.load( bean );
    menubar.loadBeanMenu( bean );
  }

  /**
   *  Closes the current project
   */

  public void closeProject() {

    if ( currentProject != null ) {

      for ( int i=0; i<frames.size(); i++ )
        ( (BuilderWindow) frames.elementAt(i) ).dispose();

      toolbar.deactivate();
      currentProject = null;
      frames = null;

    }

  }

  /**
   *  gives dialog for nw project
   */

  public void newProject() {

    String projectName = BuilderDialogs.input( this, "The name of the new project: " );

    if ( !BuilderProject.validProjectName(projectName) )
      BuilderDialogs.error( this, "You did not enter a valid project name." );
    else if ( projectName != null )
      startNewProject( projectName );

  }

  /**
   *  Starts a new project
   */

  public void startNewProject( String projectName ) {

    closeProject();

    if ( projectName != null ) {

      currentProject = new BuilderProject( projectName, this );

      frames = new Vector();

      infoWindow = new InfoWindow( this );
      desktop.add( infoWindow );
      frames.addElement( infoWindow );

      beansWindow = new BeansWindow( this );
      desktop.add( beansWindow );
      frames.addElement( beansWindow );

      propertyWindow = new PropertyWindow( this );
      desktop.add( propertyWindow );
      frames.addElement( propertyWindow );

      editorWindow = new EditorWindow( this );
      desktop.add( editorWindow );
      frames.addElement( editorWindow );

      toolbar.activate();
      menubar.setImportAction( true );
      setIconify( true );
      setIconify( false );
      BeanLoader.importDefaultBeans( this );

    }
    else BuilderDialogs.error( this, "Project Name is null" );

  }

  /**
   *  Opens a new project
   */

  public void openProject() {
    BuilderDialogs.error( this, "Not Implemented" );
  }

  /**
   *  Saves the current project
   */

  public void saveProject() {
    if ( currentProject != null ) {
      BuilderDialogs.error( this, "Not Implemented" );
    }
  }

  /**
   *  iconifies the internal frames
   */

  private void setIconify( boolean type ) {

    try {
      for ( int i=0; i<frames.size(); i++ ) {
        ((JInternalFrame)frames.elementAt(i)).setIcon(type);
      }
    }
    catch ( java.beans.PropertyVetoException e ) {
      BuilderDialogs.error( this, "There was an error de/iconifying internal frames." );
    }
  }

  /**
   *  Exits the application
   */

  public void exitApp() {
    setVisible( false );
    dispose();
    System.exit(0);
  }

}