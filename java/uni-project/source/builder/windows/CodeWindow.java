package builder.windows;

import java.awt.Container;
import javax.swing.*;

import builder.*;

public class CodeWindow extends BuilderWindow {

  private JTextArea textarea;
  private JScrollPane pane;
  private BuilderProject project;

  public CodeWindow( BuilderProject project ) {
    super( "TextView" );
    this.project = project;

    setSize(300,200);
    setLocation(300,100);

    Container c = getContentPane();
    textarea = new JTextArea();
    pane = new JScrollPane( textarea );
    c.add( pane );
    show();

    // add initial stub...
    textarea.setText( "import java.applet.Applet;\n\npublic class " +project.getName()+ " extends Applet {\n\n}" );
  }

  /**
   *  Adds a property to the code view
   */

  public void addProperty() {
  }

  /**
   *  Adds a method to the code view
   */

  public void addMethod() {
  }

}