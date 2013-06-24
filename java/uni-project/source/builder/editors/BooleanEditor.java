package builder.editors;

import java.beans.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class BooleanEditor extends PropertyEditorSupport {

  private JCheckBox checkBox;
  private JPanel panel;

  public BooleanEditor() {

    panel = new JPanel();
    panel.setLayout( new GridLayout(1,2) );

    checkBox = new JCheckBox();

    checkBox.addPropertyChangeListener( new PropertyChangeListener() {
      public void propertyChange( PropertyChangeEvent evt ) {
        BooleanEditor.this.firePropertyChange();
      }
    });

    panel.add( new JLabel("Yes/No") );
    panel.add( checkBox );

  }

  /**
   *  returns the property editor component
   */

  public Component getCustomEditor() {

    return panel;

  }

  /**
   *  sets the value of the editor
   */

  public Object getValue() {

    return new Boolean( checkBox.isSelected() );

  }

  /**
   *  returns the value of the editor
   */

  public void setValue( Object value ) {

    boolean val = ( (Boolean) value ).booleanValue();

    checkBox.setSelected( val );

  }

  /**
   *  returns the initialization string for this object
   */

  public String getJavaInitializationString() {

    if ( checkBox.isSelected() )
      return "true";
    else
      return "false";

  }

}