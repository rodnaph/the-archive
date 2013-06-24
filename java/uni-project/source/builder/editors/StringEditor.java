package builder.editors;

import java.beans.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class StringEditor extends PropertyEditorSupport {

  private JTextField textfield;
  private JPanel panel;

  public StringEditor() {

    panel = new JPanel();
    panel.setLayout( new GridLayout(1,1) );

    textfield = new JTextField();

    textfield.addPropertyChangeListener( new PropertyChangeListener() {
      public void propertyChange( PropertyChangeEvent evt ) {
        StringEditor.this.firePropertyChange();
      }
    });

    panel.add( textfield );

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

    return textfield.getText();

  }

  /**
   *  returns the value of the editor
   */

  public void setValue( Object value ) {

    textfield.setText( (String) value );

  }

  /**
   *  returns the initialization string for this object
   */

  public String getJavaInitializationString() {

    return "\"" +textfield.getText()+ "\"";

  }

}