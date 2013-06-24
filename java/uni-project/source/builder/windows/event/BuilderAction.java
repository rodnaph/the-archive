package builder.windows.event;

import javax.swing.*;

import builder.BuilderToolkit;

public abstract class BuilderAction extends AbstractAction {

  public BuilderAction( String s ) {
    super( "", new ImageIcon( BuilderToolkit.getImage(s) ) );
  }

}