package builder.windows;

import java.awt.*;
import javax.swing.*;

import builder.*;
import builder.beans.*;

public class InfoWindow extends BuilderWindow {

  private Builder builder;
  private BuilderBean bean;
  private JScrollPane pane;

  public InfoWindow( Builder builder ) {

    super( "BeanInfo" );

    this.builder = builder;

    setBounds( 0, 300, 200, 200 );

  }

  /**
   *  shows the appropriate information for the given bean
   */

  public void load( BuilderBean bean ) {

    this.bean = bean;

    JPanel panel = new JPanel();
    panel.setLayout( new GridLayout(3,0) );

    panel.add( new JLabel( " Class: " +bean.getName() ) );
    panel.add( new JLabel( " ID: $obj" +bean.getID() ) );
    panel.add( new JLabel( " FullName: " +bean.getFullName() ) );

    pane = new JScrollPane( panel );
    getContentPane().add( pane );
    show();

  }

  /**
   *  clears the info window
   */

  public void clear() {

    if ( pane != null ) remove( pane );

    pane = null;
    bean = null;

    show();

  }

}