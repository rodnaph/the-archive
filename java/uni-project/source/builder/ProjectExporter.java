package builder;

import java.awt.*;
import java.io.*;
import java.util.Vector;
import javax.swing.*;
import java.lang.reflect.*;
import java.beans.*;

import builder.beans.*;
import builder.windows.*;

public class ProjectExporter {

  public static void exportProject( Builder builder ) {

    BuilderProject project = builder.getProject();
    boolean errors = false;

    if ( project != null ) {

      //
      //  get export directory
      //

      JFileChooser chooser = new JFileChooser( "c:\\windows\\desktop" );
      File exportDir = null;

      chooser.setMultiSelectionEnabled( false );
      chooser.addChoosableFileFilter( new ExportFileFilter() );
      chooser.showSaveDialog( builder );
      exportDir = chooser.getCurrentDirectory();

      //
      //  create html file
      //

      Dimension size = builder.getEditorWindow().getSize();
      String name = project.getName();

      try {

        File htmlFile = new File(exportDir.getPath()+ "/" +name+ ".html");
        PrintWriter out = new PrintWriter( new FileWriter(htmlFile) );

        out.println( "<html>\n<head>\n<title>" +name+ "</title>\n</head>\n\n<body>\n" );
        out.println( "<applet code=\"" +name+ "/" +name+ "Comp.class\" width=\"" +new Double(size.getWidth()).intValue()+
                     "\" height=\"" +new Double(size.getHeight()).intValue()+ "\"></applet>\n" );
        out.println( "</body>\n</html>" );
        out.close();

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error creating HTML file: " +e );
        errors = true;
      }

      //
      //  add customizing methods
      //

      try {

        BufferedReader in = new BufferedReader( new FileReader( project.getFile() ) );
        PrintWriter out = new PrintWriter( new FileWriter( project.getCompFile() ) );
        String line;

        while ( (line = in.readLine()) != null ) {

          if ( line.equals("    //cust") ) {

            out.println( line );
            Vector beans = builder.getEditorWindow().getBeans();

            for ( int j=0; j<beans.size(); j++ ) {

              BuilderBean bean = (BuilderBean) beans.elementAt(j);

              try {

                Class cls = Class.forName( bean.getFullName() );
                BeanInfo bi = Introspector.getBeanInfo( cls );
                PropertyDescriptor pds[] = bi.getPropertyDescriptors();

                for ( int i=0; i<pds.length; i++ ) {
                  try {
                    PropertyDescriptor pd = pds[i];

                    if ( PropertyWindow.isReadWriteProperty( pd ) ) { // only draw read/writeable properties

                      PropertyEditor pe = PropertyEditorManager.findEditor( pd.getPropertyType() );
                      Component cp = pe.getCustomEditor();

                      if ( cp != null ) { // if there is a registered editor

                        String propName = pd.getDisplayName();
                        String temp = "" + propName.charAt(0);
                        propName = temp.toUpperCase() + propName.substring(1);

                        // set parameter types
                        Class partypes[] = new Class[0];
                        Object arglist[] = new Object[0];

                        // fetch the method, invoke amd set
                        Method meth = cls.getMethod( "get" +propName, partypes);
                        pe.setValue( meth.invoke(bean.self, arglist) );

                        out.println( "    $obj" +bean.getID()+ ".set" +propName+ "( " +pe.getJavaInitializationString()+ " );" );

                      }

                    }

                  }
                  catch( Exception e ) {}
                }
              }
              catch ( Exception e ) {
                System.err.println( "Error Adding Customizers" );
                errors = true;
              }

            } // end bean loop

          }
          else out.println( line );

        }

        in.close();
        out.close();

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error adding customizer methods" );
        errors = true;
      }

      //
      //  compile classes
      //

      try {

        Runtime rt = Runtime.getRuntime();
        rt.exec( "javac -d " +exportDir.getPath()+ " " +project.getCompFile().getPath() );

      }
      catch ( Exception e ) {
        BuilderDialogs.error( builder, "Error compiling classes" );
        errors = true;
      }

      //
      //  signal success
      //

      if ( !errors )
        BuilderDialogs.inform( builder, "Project Exported!" );

    }

  }

  /**
   *  filter for selecting directories
   */

  private static class ExportFileFilter extends javax.swing.filechooser.FileFilter {

    public boolean accept( File f ) {

      if ( f.isDirectory() ) return true;
        else return false;

    }

    public String getDescription() {
      return "Export Directory";
    }

  }

}