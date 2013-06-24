package builder;

import java.io.*;
import java.awt.*;
import java.util.*;
import javax.swing.*;
import javax.swing.filechooser.*;

import builder.windows.*;

public class ProjectManager {

  /**
   *  saves the current project (if there is one)
   */

  public static void saveProject( Builder builder ) {

    JFileChooser chooser = new JFileChooser( "c:\\windows\\desktop\\project\\SavedProjects" );
    File file = null;
    String dir = null;

    chooser.setMultiSelectionEnabled( false );
    chooser.addChoosableFileFilter( new OpenFileFilter() );

    if ( chooser.showSaveDialog( builder ) == JFileChooser.APPROVE_OPTION ) {
       dir = chooser.getCurrentDirectory().getPath();
       String filename = chooser.getSelectedFile().getName();

       if ( !filename.toLowerCase().endsWith(".btp") ) filename += ".btp";
       file = new File( dir+ "/" +filename );
    }

    BuilderProject project = builder.getProject();
    boolean errors = false;

    if ( (project != null) && (file != null) ) {

      // set file names
      String base = dir+ "/" +project.getName()+ "_" +file.getName();
      String beansFile = base+ "-beans.ser";
      String linksFile = base+ "-links.ser";
      String codeFile = base+ "-code.btc";

      try {

        //
        //  perform serialization
        //

        FileOutputStream fos = null;
        ObjectOutputStream sout = null;

        fos = new FileOutputStream( beansFile );
        sout = new ObjectOutputStream( fos );
        sout.writeObject( builder.getEditorWindow().getBeans() );
        sout.close();

        fos = new FileOutputStream( linksFile );
        sout = new ObjectOutputStream( fos );
        sout.writeObject( builder.getEditorWindow().getLinks() );
        sout.close();

        //
        //  save code file
        //

        BufferedReader bin = new BufferedReader( new FileReader( project.getFile().getPath() ) );
        PrintWriter bout = new PrintWriter( new FileWriter(new File(codeFile)) );
        String line;

        while ( (line = bin.readLine()) != null )
          bout.println( line );

        bin.close();
        bout.close();

        //
        //  write data file
        //

        PrintWriter out = new PrintWriter( new FileWriter(file) );

        out.println( dir );
        out.println( project.getName() );
        out.println( beansFile );
        out.println( linksFile );
        out.println( project.getFile().getPath() );
        out.println( codeFile );
        out.println( builder.getEditorWindow().getID() );
        out.close();

      }
      catch ( Exception e ) {
        errors = true;
        BuilderDialogs.error( builder, "Error serializing saving the project: " +e );
      }

      if ( !errors )
        BuilderDialogs.inform( builder, "Project Saved!" );

    }
    else BuilderDialogs.error( builder, "There is no project open" );

  }

  /**
   *  loads a saved project from disk
   */

  public static void loadProject( Builder builder ) {

    JFileChooser chooser = new JFileChooser( "c:\\windows\\desktop\\project\\SavedProjects" );
    File file = null;

    chooser.setMultiSelectionEnabled( false );
    chooser.addChoosableFileFilter( new OpenFileFilter() );

    if ( chooser.showOpenDialog( builder ) == JFileChooser.APPROVE_OPTION )
       file = chooser.getSelectedFile();

    if ( file != null ) {

      String dir, name = null, beanFile, linkFile, codeTo, codeFrom;
      Vector beans = null, links = null;
      FileInputStream fis = null;
      ObjectInputStream sin = null;
      boolean errors = false;
      int objID = -1;

      //
      //  read data in...
      //

      try {

        BufferedReader in = new BufferedReader( new FileReader(file) );

        // read data
        dir = in.readLine();
        name = in.readLine();
        beanFile = in.readLine();
        linkFile = in.readLine();
        codeTo = in.readLine();
        codeFrom = in.readLine();
        objID = Integer.parseInt( in.readLine() );
        in.close();

        // close current project and start new
        builder.closeProject();
        builder.startNewProject( name );

        // read beans vector
        fis = new FileInputStream( beanFile );
        sin = new ObjectInputStream( fis );
        beans = (Vector) sin.readObject();
        sin.close();

        // read links vector
        fis = new FileInputStream( linkFile );
        sin = new ObjectInputStream( fis );
        links = (Vector) sin.readObject();
        sin.close();

        // create code file
        File toFile = new File( codeTo );
        BufferedReader bin = new BufferedReader( new FileReader( codeFrom ) );
        PrintWriter bout = new PrintWriter( new FileWriter(toFile) );
        String line;

        while ( (line = bin.readLine()) != null )
          bout.println( line );

        bin.close();
        bout.close();

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error Loading Project" );
        errors = true;
      }

      if ( !errors ) {

        // put project back together
        builder.getEditorWindow().setLinks( links );
        builder.getEditorWindow().setBeans( beans );
        builder.getEditorWindow().setID( objID );
        builder.getEditorWindow().deselectAll();

      }
      else builder.closeProject();

    }

  }

  /**
   *  class for filtering files
   */

  private static class OpenFileFilter extends javax.swing.filechooser.FileFilter {

    /**
     *  checks whether or not the file is to be displayed
     */

    public boolean accept( File f ) {

      if ( f.isDirectory() || f.getName().toLowerCase().endsWith(".btp") )
        return true;

      return false;

    }

    /**
     *  returns a description of the file type
     */

    public String getDescription() {
      return "Builder Tool Project (*.btp)";
    }

  }

}