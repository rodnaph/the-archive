<?php

class Smutty_Controller_Factory extends Smutty_Object {

    private $db;

    /**
     *  Creates a new controller factory
     * 
     *  @param Smutty_Database $db
     * 
     */

    public function __construct( $db ) {

        $this->db = $db;

    }

    /**
     *  Creates and returns a new controller by name
     * 
     *  @param string $name
     * 
     *  @return Smutty_Controller
     * 
     */

    public function getController( $name ) {

		$smuttyControllers = array( 'smutty' );
		$isSmuttyController = in_array( strtolower($this->controller), $smuttyControllers );
		$controllerClass = $name . 'Controller';

		if ( $isSmuttyController ) {
			$controllerClass = 'Smutty_Controller_' . ucfirst($name);
			Smutty_Main::loadClass( $controllerClass );
		}
		else {
			$controllerFile = 'application/controllers/' . $name . 'Controller.php';
			if ( !file_exists($controllerFile) )
				Smutty_Error::fatal( ERR_CONTROLLER_INVALID, 'ClassSmutty_Controller', 404 );
			include_once $controllerFile;
		}

        $controller = new $controllerClass();
        
        return $controller;

    }

}