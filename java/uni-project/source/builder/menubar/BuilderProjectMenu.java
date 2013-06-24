package builder.menubar;

import java.awt.event.*;
import javax.swing.*;

import builder.*;

public class BuilderProjectMenu extends JMenu {

  private Builder builder;

  public BuilderProjectMenu( Builder builder ) {
    super( "Project" );
    this.builder = builder;

    add( new AbstractAction( "New" ) {
      public void actionPerformed( ActionEvent evt ) {
        BuilderProjectMenu.this.builder.newProject();
      }
    });

    add( new LoadAction( builder ) );
    add( new SaveAction( builder ) );

    add( new AbstractAction( "Close" ) {
      public void actionPerformed( ActionEvent evt ) {
        BuilderProjectMenu.this.builder.closeProject();
      }
    });

  }

  /**
   *  class to start saving a project
   */

  private class SaveAction extends AbstractAction {

    private Builder builder;

    public SaveAction( Builder builder ) {
      super( "Save As" );
      this.builder = builder;
    }

    public void actionPerformed( ActionEvent evt ) {
      ProjectManager.saveProject( builder );
    }

  }

  /**
   *  starts the loading process
   */

  private class LoadAction extends AbstractAction {

    private Builder builder;

    public LoadAction( Builder builder ) {
      super( "Open" );
      this.builder = builder;
    }

    public void actionPerformed( ActionEvent evt ) {
      ProjectManager.loadProject( builder );
    }

  }

}