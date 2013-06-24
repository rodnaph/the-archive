package builder.windows;

import javax.swing.JInternalFrame;
import java.awt.event.WindowAdapter;

public class BuilderWindow extends JInternalFrame {

  public BuilderWindow( String title ) {
    super( title, true, false, true, true );
  }

}