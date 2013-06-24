package builder;

import java.awt.Image;
import java.awt.Toolkit;

public class BuilderToolkit {

  public static final String IMAGES = "images\\";

  public static String getImage( String s ) {
    return IMAGES + s;
  }

  public static Image createImage( String s ) {
    return Toolkit.getDefaultToolkit().getImage( getImage(s) );
  }

}