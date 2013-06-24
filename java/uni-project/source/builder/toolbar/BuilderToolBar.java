package builder.toolbar;

import java.awt.*;
import javax.swing.*;

import builder.lnf.event.*;

public class BuilderToolBar extends JToolBar {

  private JButton metalButton, motifButton, winButton;

  public BuilderToolBar( JFrame f ) {

    setLayout( new FlowLayout(FlowLayout.LEFT) );

    LnFListener lnf = new LnFListener( f );

    metalButton = new JButton("Metal");
    metalButton.setActionCommand( LnFListener.METAL );
    metalButton.addActionListener( lnf );
    add( metalButton );

    motifButton = new JButton("Basic");
    motifButton.setActionCommand( LnFListener.BASIC );
    motifButton.addActionListener( lnf );
    add( motifButton );

    winButton = new JButton("Multi");
    winButton.setActionCommand( LnFListener.MULTI );
    winButton.addActionListener( lnf );
    add( winButton );

    deactivate();

  }

  /**
   *  Activates the toolbars buttons sensitive to projects
   */

  public void activate() {
  }

  /**
   *  De-activates the toolbars buttons sensitive to projects
   */

  public void deactivate() {
  }

}