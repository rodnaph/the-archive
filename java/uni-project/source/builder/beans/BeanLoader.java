package builder.beans;

import java.io.*;

import builder.exceptions.*;
import builder.windows.*;
import builder.*;
import builder.beans.*;

public class BeanLoader {

  public static LoadedBean loadBean( String cls ) throws BeanLoadException {

    LoadedBean bean = new LoadedBean( cls );

    try {
      Class c = Class.forName( cls );
    }
    catch ( Exception e ) {
      throw new BeanLoadException();
    }

    return bean;

  }

  /**
   *  imports a bean into the current project
   */

  public static void importBean( Builder builder, String name ) {

    try {
      LoadedBean newBean = BeanLoader.loadBean( name );
      builder.getBeansWindow().addBean( newBean, newBean.getFullName() );
    }
    catch ( BeanAlreadyLoadedException e ) {
      BuilderDialogs.error( builder, name+" has already been imported." );
    }
    catch ( BeanLoadException e ) {
      BuilderDialogs.error( builder, "class "+name+" failed to load." );
    }

  }

  /**
   *  imports the standard beans listed in BuilderConstants.DEFAULT_BEANS
   */

  public static void importDefaultBeans( Builder builder ) {

    try {

      File f = new File( BuilderConstants.DEFAULT_BEANS );
      BufferedReader in = new BufferedReader( new FileReader(f) );
      String line;

      while ( (line = in.readLine()) != null )
        importBean( builder, line );

      in.close();

    }
    catch ( Exception e ) {
      BuilderDialogs.error( builder, "Error Loading Default Beans" );
    }

  }

}