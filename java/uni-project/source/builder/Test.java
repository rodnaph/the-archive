package builder;

import bsh.*;

public class Test {

  public static void main( String args[] ) throws EvalError {

    Interpreter bsh = new Interpreter();

    int i;

    bsh.setVariable( i, 10 );
    bsh.eval( "i += 10" );
    bsh.print( i );

  }

}