package builder.lnf.event;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class LnFListener implements ActionListener {

  public static final String METAL = "javax.swing.plaf.metal.MetalLookAndFeel";
  public static final String BASIC = "javax.swing.plaf.basic.BasicLookAndFeel";
  public static final String MULTI = "javax.swing.plaf.multi.MultiLookAndFeel";

  Frame frame;

  public LnFListener( Frame frame ) {
    this.frame = frame;
  }

  public void actionPerformed( ActionEvent evt ) {
    try {
    /* currently unimplemented */
//      UIManager.setLookAndFeel( evt.getActionCommand() );
//      SwingUtilities.updateComponentTreeUI( frame );
    } catch ( Exception e ) {
      System.out.println( "Error setting LookAndFeel: "+e );
    }
  }

}