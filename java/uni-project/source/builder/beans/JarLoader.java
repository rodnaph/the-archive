package builder.beans;

import java.io.*;
import java.util.zip.*;
import java.util.jar.*;
import java.util.*;

public class JarLoader {

  public static final String PACKAGES = "c:\\jdk1.2.2\\packages\\";

  public static void main( String args[] ) {

    try {
      File f = new File( "c:\\Bdk1.1\\jars\\eventmonitor.jar" );
      JarFile jf = new JarFile( f );
      Manifest m = jf.getManifest();
      Attributes a = m.getMainAttributes();
      Set keys = a.keySet();
      Iterator i = keys.iterator();

      String name = null, dependsOn = null;
      boolean isBean = false;

      while ( i.hasNext() ) {
        Object o = i.next();
        if ( o.toString().equals("Name") ) {
          name = a.get(o).toString();
        } 
        else if ( o.toString().equals("Java-Bean") && a.get(o).toString().equals("True")) {
          isBean = true;
        }
      }

      if ( isBean ) {
        ZipFile zipfile = new ZipFile( f );
        ZipEntry zipentry = zipfile.getEntry( name );
        InputStream in = zipfile.getInputStream( zipentry );
        BufferedInputStream bis = new BufferedInputStream( in );

        String dir = name.substring( 0,name.lastIndexOf('/') );
        File destFile = new File( PACKAGES + dir );
        destFile.mkdirs();
        destFile = new File( PACKAGES + name );
        FileWriter dest = new FileWriter( destFile );

        int c;
        while ( (c = bis.read()) != -1 ) {
          System.out.println( c );
          dest.write( c );
        }
      }

    }
    catch ( Exception e ) {
      System.out.println( "Error Loading Jar File:" + e );
    }

    try {
//      Class c = Class.forName( "sunw.demo.encapsulatedEvents.EventMonitor" );
    }
    catch ( Exception e ) {
      System.out.println( "ClassLoadFail" );
    }

  }

}