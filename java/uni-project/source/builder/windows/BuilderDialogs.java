package builder.windows;

import java.awt.*;
import javax.swing.*;

public class BuilderDialogs extends JOptionPane {

  public static String input( JFrame frame, String content ) {
    return showInputDialog( frame, content);
  }

  public static void error( JFrame frame, String content ) {
    showMessageDialog( frame, content, "Error", WARNING_MESSAGE );
  }

  public static void inform( JFrame frame, String content ) {
    showMessageDialog( frame, content, "", INFORMATION_MESSAGE  );
  }

}
