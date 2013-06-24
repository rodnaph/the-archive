package builder.editors;

import java.io.*;
import java.util.*;
import java.beans.*;

import builder.*;

public class BuilderEditorManager {

  /**
   *  registers a new editor
   */

  public static void registerNewEditor( Class cls, Class editor ) {

    registerEditor( cls, editor );

    // store in editor file

  }

  /**
   *  register editor
   */

  public static void registerEditor( Class cls, Class editor ) {
    PropertyEditorManager.registerEditor( cls, editor );
  }

  /**
   *  registers thge default property editors with the property
   *  editor manager
   */

  public static void loadDefaultEditors() {

    try {

      File f = new File( BuilderConstants.EDITORS_FILE );
      BufferedReader in = new BufferedReader( new FileReader(f) );
      String line;

      while ( (line = in.readLine()) != null ) {

        StringTokenizer stk = new StringTokenizer( line, ":" );
        Class cls = Class.forName( stk.nextToken() );
        Class editor = Class.forName( stk.nextToken() );

        registerEditor( cls, editor );

      }

      in.close();

    }
    catch ( Exception e ) {
      System.err.println( "ErrorReading: " +e.getMessage() );
    }

  }

}