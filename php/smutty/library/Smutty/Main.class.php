<?php

function singlemess() {
    echo '<h1>SINGLETON!</h1><pre>';
    print_r( debug_backtrace() );
    exit;
}

/**
 *  this is the main class in the application.  it provides a
 *  few methods of use like loadClass(), 
 *
 */

class Smutty_Main extends Smutty_Object {

    public function init() {}

	/**
	 *  loads a class by name.  some classes may have special
	 *  things done when loaded (like user models)
	 *
	 *  @param String $class class name
	 *  @return boolean indicating success
	 *
	 */

	public function loadClass( $class ) {

		// first try the smutty library
		$path = preg_replace( '/_/', '/', $class );
		$path = "library/$path.class.php";
		if ( file_exists($path) )
			return include( $path );

		else {

			// then maybe a model?
			$path = "application/models/$class.php";
			if ( file_exists($path) ) {
                            require_once $path;
                            return true;
			}

		}

		// class not found
		return false;

	}

	/**
	 *  this is the entry point of the application, call this
	 *  to get everything going!!!
	 *
	 *  @return nothing
	 *
	 */
    
    public function run() {

        $cfg = new Smutty_Config();
        $err = new Smutty_Error( $cfg );

        try {

            $cfg->loadDefaults();

            // set error handler and error reporting level
            //set_error_handler(array( $err, 'fatal' ));
            switch ( $cfg->get('errors') ) {
                case 'all':
                    $err->setErrorReporting( ERR_ALL );
            }

            $this->setLanguage( $cfg );

            // first check the resource to see if it's a public
            // resource that the user has requested.
            $resource = Smutty_Utils::getSmuttyUrl();
            if ( substr($resource,0,6) != 'smutty' ) {
                $path = "application/public/$resource";
                if ( $resource && file_exists($path) && !is_dir($path) ) {
                    // @TODO
                    //$res = new Smutty_Resource();
                    //$res->output();
                    Smutty_Resource::output( $path );
                }
            }

            // we should now be able to allow the error
            // reporting to use smarty templates
            $err->enableTemplates();

            $sess = new Smutty_Session( $_SESSION, $cfg );
            $sess->init();

            $controllerFactory = new Smutty_Controller_Factory( null );

            // then create the router and dispatch the request
            $router = new Smutty_Router( $cfg, $sess, $controllerFactory );
            $router->init();
            $router->dispatch();

            self::completeRequest();

        }
        
        catch ( Exception $e ) {
            
            echo '<pre>';
            throw $e;

            //$err->fatal( $e->getMessage(), '', 500 );
            
        }

	}

	/**
	 *  includes the correct langauge file
	 *
	 *  @return nothing
	 *
	 */

	public function setLanguage( $cfg ) {

		$lang = $cfg->get('smutty.lang')
            ? $cfg->get('smutty.lang')
            : 'en';

        include "library/lang/$lang.php";

	}

	/**
	 *  this function does any cleanup/saving needed
	 *  before the request is done.
	 *
	 *  @return nothing
	 *
	 */

	public static function completeRequest() {

		$session =& Smutty_Session::getInstance();
		$session->save();

	}

	/**
	 *  loads any model classes the user has created
	 *
	 *  @return nothing
	 *
	 */

	public static function loadModelClasses() {

		$d = opendir( 'application/models/' );

		while ( $f = readdir($d) )
			if ( preg_match('/(.*)\.php$/',$f,$matches) )
				Smutty_Main::loadClass( $matches[1] );

		closedir( $d );

	}

}
