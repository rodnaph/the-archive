package builder.menubar;

import java.awt.event.*;
import javax.swing.*;

import builder.Builder;

public class BuilderFileMenu extends JMenu {

  private Builder builder;

  public BuilderFileMenu( Builder builder ) {
    super( "File" );
    this.builder = builder;

    add( new BuilderProjectMenu( builder ) );

    add( new AbstractAction( "Exit" ) {
      public void actionPerformed( ActionEvent evt ) {
        BuilderFileMenu.this.builder.exitApp();
      }
    });

  }

}