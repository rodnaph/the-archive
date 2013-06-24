package builder.beans;

import java.lang.reflect.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.beans.*;
import java.util.*;

import builder.*;
import builder.windows.*;

public class BuilderBean implements java.io.Serializable {

  private String name;
  private Point position;
  public Object self;
  private boolean selected = false;
  private int id;
  private Image image = null;

  public BuilderBean( String name, Builder builder, int x, int y, int id ) {

    this.name = name;
    this.position = new Point( x, y );
    this.id = id;

    try {

      // instantiate bean
      this.self = Beans.instantiate( Class.forName(getFullName()).getClassLoader(), getLoadInfo() );
      builder.getEditorWindow().placeBean( x, y, this );

      // set an image
      this.image = BeanImageManager.getBeanImage( Class.forName(getFullName()) );

    }
    catch ( Exception e ) {
      BuilderDialogs.error( builder, "Error Instantiating Bean" );
    }

  }

  /**
   *  draws the bean
   */

  public void draw( Graphics g ) {

    if ( hasImage() ) {

      // draw the image for the bean
      g.drawImage( image, getPosition().x, getPosition().y, (java.awt.image.ImageObserver) this );

    }
    else {

      // draw simple bounding box

      if ( isSelected() ) {
        g.setColor( Color.blue );
        g.drawRect( getPosition().x, getPosition().y,
                    getSize().width, getSize().height );
      }

      g.setColor( Color.black );
      g.drawString( toString(), getPosition().x, getPosition().y );

    }

  }

  /**
   *  whether or not the bean has an image
   */

  public boolean hasImage() {

    if ( image != null ) return true;

    return false;

  }

  /**
   *  returns the appropriate info for loading the bean
   */

  public String getLoadInfo() {
    return getFullName();
  }

  /**
   *  for comparing BuilderBean's
   */

  public boolean equals( BuilderBean bean ) {
    if ( getName().equals( bean.getName() ) ) return true;
    return false;
  }

  /**
   *  tests whether the bean covers the given point
   */

  public boolean contains( int x, int y ) {

    Point pos = getPosition();
    Dimension d = getSize();
    Rectangle r = new Rectangle( pos.x, pos.y, d.width, d.height );

    return r.contains( x, y );

  }

  public String toString() {
    return getName();
  }

  // getters
  public String getName() { return name.substring( name.lastIndexOf('.') + 1 ); }
  public String getFullName() { return name; }
  public Point getPosition() { return position; }
  public void setPosition( Point position ) { this.position = position; }
  public Dimension getSize() { return new Dimension(50,50); }
  public int getID() { return id; }

  public boolean isSelected() { return selected; }
  public void setSelected( boolean b ) { selected = b; }

}