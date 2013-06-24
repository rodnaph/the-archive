package builder.windows;

import javax.swing.JWindow;
import java.awt.Graphics;
import java.awt.Image;

import builder.BuilderToolkit;

public class BuilderSplashScreen extends JWindow {

  /**
   *  The status text that appears in the bottom left corner.
   *  This property is accessed with the setStatus method.
   */

  private String status;

  /**
   *  The main image
   */

  private Image image;

  public BuilderSplashScreen( int duration ) {
    setSize(400,200);
    setLocation(200,200);
    status = "Initializing...";
    image = BuilderToolkit.createImage( "splash.jpg" );
    show();

    pause( duration );
  }

  /**
   *  Pauses the execution of the screen
   *
   *  @param delay is to be specified in milliseconds
   */

  private void pause( int delay ) {
    try { Thread.sleep( delay ); }
    catch ( Exception e ) {}
  }

  /**
   *  Sets the text displayed on the splash screen
   */

  public void setStatus( String status ) {
    this.status = status;
    repaint();
    pause( 500 );
  }

  /**
   *  Closes and disposes of the splash screen
   */

  public void close() {
    setVisible( false );
    dispose();
  }

  /**
   *  Responsible for painting the contents of the splash screen
   *
   *  @param this method is called internally by Component which gives
   *  it this parameter
   */

  public void paint( Graphics g ) {
    g.drawImage(image, 0,0, 400,200, this );
    g.drawString( status, 15,185 );
  }

}