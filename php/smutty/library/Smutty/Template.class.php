<?php

include_once 'library/smarty/src/Smarty.class.php';

/**
 *  this is Smutty's customized subclass of a smarty template
 *
 */

class Smutty_Template extends Smarty {

	/**
	 *  contructor.  sets up our customised version
	 *  of the smarty template.
	 *
	 *  @return nothing
	 *
	 */

	public function __construct() {

		// we use diff dirs for each app using smutty to make
		// sure if they're sharing the same filenames they don't
		// tread on each others toes.
		$compileDir = 'library/smarty/cache/application/' . md5(getcwd());
		if ( !file_exists($compileDir) )
			if ( !mkdir($compileDir) )
				Smutty_Error::fatal( 'could not create compile directory, ' .
					'check write permissions on library/smarty/cache',
					'SmuttyInstall' );

		$this->compile_dir = $compileDir;
		$this->template_dir = 'application/views/';
		$this->plugins_dir[] = 'library/smarty/plugins/'; // smutty plugins
		$this->plugins_dir[] = 'application/plugins/'; // app plugins
		$this->autoload_filters = array(
			'pre' => array( 'allow_assoc_attrs' )
		);

	}

	/**
	 *  displays a template.
	 *
	 *  @param String $file template file
	 *  @return nothing
	 *
	 */

	public function display( $file ) {

		$router = Smutty_Router::getInstance();
		$session = Smutty_Session::getInstance();

		// create the smutty variable
		$smutty = new stdclass();
		$smutty->session = $session;
		$smutty->user = $session->user;
		$smutty->smuttyUrl = Smutty_Utils::getSmuttyUrl();
		$smutty->baseUrl = Smutty_Utils::getBaseUrl();

		// add get params
		$smutty->get = new stdclass();
		if ( $_SERVER['REQUEST_METHOD'] == 'GET' )
			foreach ( $_GET as $key => $value )
				$smutty->get->$key = $value;

		$this->assign( 'smutty', $smutty );

		// try to use controller shortcut for filenames, if it
		// fails then fall back on the filename
		$path = strtolower($router->getControllerName()) . "/$file";
		if ( !file_exists("$this->template_dir$path") )
			$path = $file;

		$errorType = Smutty_Error::getErrorReporting();
		Smutty_Error::setErrorReporting( ERR_STANDARD );
		parent::display( $path );
		Smutty_Error::setErrorReporting( $errorType );

	}

	/**
	 *  this function loads another smarty plugin, specified
	 *  by type (function/modifier/etc...) and name.
	 *
	 *  @param String $type the plugin type
	 *  @param String $name the plugin name
	 *  @return nothing
	 *
	 */

	public function depend( $type, $name ) {

		$path = $this->_get_plugin_filepath( $type, $name );
		if ( file_exists($path) )
			require_once $path;
		else
			Smutty_Error::fatal( "plugin not found $type.$name", 'ClassSmutty_Template' );

	}

}

?>