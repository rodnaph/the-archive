package builder.beans;

import java.awt.*;
import java.util.*;
import java.io.*;

public class BeanImageManager {

  private static final String IMG_FILE = "beanImages.dat";

  public static void registerBeanImage( String className, String imgSource ) {

    try {

      // get beans and open file stream
      Vector images = getBeanImages();
      File imagesFile = new File( IMG_FILE );
      PrintWriter out = new PrintWriter( new FileWriter( imagesFile ) );

      // create new bean image
      images.addElement( new BeanImage( className, imgSource ) );

      // add info to file
      for ( int i=0; i<images.size(); i++ ) {

        BeanImage beanImage = (BeanImage) images.elementAt(i);

        out.println( beanImage.getBeanClass().getName()+ ":#:" +
                     beanImage.getImageSource()+ "\n" );

      }

      // close stream
      out.close();

    }
    catch ( Exception e ) {
      System.err.println( "Error Registering Bean Image: " +e );
    }

  }

  /**
   *  returns the registered image for a class
   */

  public static Image getBeanImage( Class cls ) {

    // get bean images
    Vector images = getBeanImages();

    // look for registered image match
    for ( int i=0; i<images.size(); i++ ) {

      BeanImage beanImage = (BeanImage) images.elementAt(i);
      Class beanClass = beanImage.getBeanClass();

      // if match found return image
      if ( beanClass.equals( cls ) )
        return beanImage.getImage();
      else
       System.out.println( beanClass );

    }

    // no match found
    return null;

  }

  /**
   *  loads and returns all registered images
   */

  private static Vector getBeanImages() {

    Vector images = new Vector();
    File imageFile = new File( IMG_FILE );

    if ( imageFile.exists() ) {

      try {

        BufferedReader in = new BufferedReader( new FileReader( imageFile ) );
        String line;

        while ( (line = in.readLine()) != null ) {

          StringTokenizer stk = new StringTokenizer( line, ":#:" );
          String className = stk.nextToken();
          String imgSource = stk.nextToken();

          images.addElement( new BeanImage( className, imgSource ) );

        }

        in.close();

      }
      catch ( Exception e ) {}

    }

    return images;

  }

  /**
   *  class representing a bean image
   */

  private static class BeanImage {

    private String className, imgSource;

    public BeanImage( String className, String imgSource ) {

      this.className = className;
      this.imgSource = imgSource;

    }

    /**
     *  returns the Class of the class
     */

    public Class getBeanClass() {

      try {

        return Class.forName( className );

      }
      catch ( Exception e ) {}

      return null;

    }

    /**
     *  returns the classes image
     */

    public Image getImage() {

      return Toolkit.getDefaultToolkit().getImage( imgSource );

    }

    /**
     *  returns the image source
     */

    public String getImageSource() {

      return imgSource;

    }

  }

}