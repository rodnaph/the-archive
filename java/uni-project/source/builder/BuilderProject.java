package builder;

import java.io.*;
import java.lang.reflect.*;

import builder.beans.*;
import builder.windows.*;
import builder.windows.event.*;

public class BuilderProject {

  private String name, mainFile, mainDir, compFile;
  private Builder builder;

  public BuilderProject( String name, Builder builder ) {
    this.name = name;
    this.builder = builder;

    mainDir = System.getProperty( "java.class.path" ) +"/"+ name;
    mainFile = mainDir+ "/" +name+ ".java";
    compFile = mainDir+ "/" +name+ "Comp.java";

    setupDirectory();
    setupMainFile();
  }

  /**
   *  sets up the project directory
   */

  private void setupDirectory() {

    // setup directory stuff
    File f = new File( mainDir );
    f.mkdir();

  }

  private void setupMainFile() {

    try {

      File f = new File( mainFile );
      f.createNewFile();

      PrintWriter out = new PrintWriter( new FileWriter(f) );

      out.println( "//[$Created with Builder$]\n\n" +
                   "package "+name+";\n\n\npublic class "+name+"Comp extends java.applet.Applet {\n\n" +
                   "  //fields\n\n\n  public void init() {\n    //cont\n\n    //cust\n\n    //handlers\n\n  }\n\n  //meths\n\n}" );
      out.close();

    }
    catch ( Exception e ) {
      System.out.println( "ErrorCreatingMainFile" );
    }

  }

  private void copyFile( String fromName, String toName ) {

    try {

      // setup files
      File from = new File( fromName );
      File to = new File( toName );

      // create new file
      to.createNewFile();

      // open streams
      BufferedReader in = new BufferedReader( new FileReader(from) );
      PrintWriter out = new PrintWriter( new FileWriter(to) );

      // copy data
      String line;
      while ( (line = in.readLine()) != null )
        out.println( line );

      // close streams
      in.close();
      out.close();

    }
    catch ( Exception e ) {
      System.err.println( "[ErrorCopyingFile] " +e.getMessage() );
    }

  }

  /**
   *  adds a specified field
   */

  public void addField( BuilderBean bean ) {

    String field = "  public " +bean.getFullName()+ " $obj" +bean.getID();
    String cont = "    try {\n      $obj" +bean.getID()+ " = (" +bean.getFullName()+ ") " +
                  "java.beans.Beans.instantiate( Class.forName( \"" +bean.getFullName()+
                  "\" ).getClassLoader(), \"" +bean.getFullName()+ "\" );" +
                  "\n      add( $obj" +bean.getID()+ " );\n    } catch ( Exception e ) { System.err.println(e); }\n";

    try {

      // create files
      File f = new File( mainFile );
      File t = File.createTempFile( "temp", "tmp" );

      // open streams
      BufferedReader in = new BufferedReader( new FileReader(f) );
      PrintWriter out = new PrintWriter( new FileWriter(t) );

      // add field
      String line;
      while ( (line = in.readLine()) != null ) {
        if ( line.equals("  //fields") ) {
          out.println( field+ ";\n" +line+ "\n" );
        }
        else if ( line.equals("    //cont") ) {
          out.println( cont+line+ "\n" );
        }
        else out.println( line );
      }

      // close streams
      in.close();
      out.close();

      // copy file
      copyFile( t.getPath(), f.getPath() );

    }
    catch ( Exception e ) {
      System.err.println( "[AddFieldError] " +e.getMessage() );
    }

  }

  /**
   *  adds an event link
   */

  public void addEventLink( BuilderBean b, Method m, EventPackage ep ) {

    try {

      // create files
      File f = new File( mainFile );
      File t = File.createTempFile( "temp", "tmp" );

      // open streams
      BufferedReader in = new BufferedReader( new FileReader(f) );
      PrintWriter out = new PrintWriter( new FileWriter(t) );

      // add hookup
      String line;
      while ( (line = in.readLine()) != null ) {
        if ( line.equals("    //handlers") ) {

          String type = ep.getType().substring( ep.getType().lastIndexOf('.')+1 );

          out.println( line+"\n    $obj" +ep.getSource().getID()+ ".add" +type+ "( new "+ep.getType()+"() {" );

          Method[] methods = ep.getListener().getMethods();

          for ( int i=0; i<methods.length; i++ ) {

            Method method = methods[i];
            Class[] params = method.getParameterTypes();
            String param = params[0].getName();

            out.println( "      public void "+method.getName()+"( "+param+" evt ) {" );

            // add hookup if needed
            if ( method.getName().equals( ep.getMethod().getName() ) ) {
              out.println( "        try { " );
              out.println( "          $obj" +b.getID()+ "." +m.getName()+ "();" );
              out.println( "        } catch ( Exception e ) { System.err.println(e); }" );
            }

            out.println( "      }" );

          }

          out.println( "    });\n" );

        }
        else out.println( line );
      }

      // close streams
      in.close();
      out.close();

      // copy file
      copyFile( t.getPath(), f.getPath() );

    }
    catch ( Exception e ) {
      System.err.println( "[LinkingError] " +e.getMessage() );
    }

  }

  /**
   *  get comp file
   */

  public File getCompFile() {
    return new File( compFile );
  }

  /**
   *  returns the name of the project
   */

  public String getName() {
    return name;
  }

  /**
   *  return the main file
   */

  public File getFile() {
    return new File( mainFile );
  }

  /**
   *  tests whether a given name is valid
   */

  public static boolean validProjectName( String name ) {

    if ( name == null ) return false;

    if ( name.equals("") ) return false;

    return true;

  }

}