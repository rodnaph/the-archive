<?php

/**
 *  this class is the command line "smut" utility. it implements
 *  all the actions like creating models, controllers, etc...
 *
 */

class Smutty_Smut extends Smutty_Object {

	/**
	 *  prints out a usage message for smut
	 *
	 *  @return nothing
	 *
	 */

	private function usage() {
		$tpl = new Smutty_Template_Smutty();
		$tpl->display( 'smut/usage.tpl' );
		exit();
	}

	/**
	 *  creates a controller
	 *
	 *  @param String $name the name of the controller
	 *  @return nothing
	 *
	 */

	private function createController( $name ) {
		// write the controller file
		$tpl = new Smutty_Template_Smutty();
		$tpl->assign( 'name', $name );
		$this->writeFile(
			'application/controllers/' . $name . 'Controller.php',
			$tpl->fetch('smut/controller.tpl')
		);
		// make sure views folder exists
		$viewFolder = 'application/views/' . strtolower($name);
		if ( !file_exists($viewFolder) )
			mkdir( $viewFolder );
	}

	/**
	 *  creates a model
	 *
	 *  @param String $name the name of the model to create
	 *  @return nothing
	 *
	 */

	private function createModel( $name ) {
		$tpl = new Smutty_Template_Smutty();
		$tpl->assign( 'name', $name );
		$this->writeFile(
			'application/models/' . $name . '.php',
			$tpl->fetch('smut/model.tpl')
		);
	}

	/**
	 *  writes the given data to the specified file
	 *
	 *  @param String $path the path of the file
	 *  @param String $data the data to write
	 *  @return nothing
	 *
	 */

	private function writeFile( $path, $data ) {
		$f = fopen( $path, 'w' );
		fputs( $f, $data );
		fclose( $f );
	}

	/**
	 *  runs a single test case
	 *
	 *  @param String $name the name of the test
	 *  @return nothing
	 *
	 */

	private function runTest( $name ) {

		$suite = new Smutty_Test_Suite( 'application/tests' );
		$suite->addTest( $name );
		$suite->run();

	}

	/**
	 *  this action makes sure everything is set up for smutty
	 *
	 *  @return nothing
	 *
	 */

	private function setup() {

		//
		//  app.cfg
		//
		$appFile = 'application/app.cfg';
		echo 'Checking app.cfg... ';
		if ( !file_exists($appFile) ) {
			echo 'not found, creating... ';
			copy( "$appFile-sample", $appFile );
		}
		echo "Ok!\n";

		//
		//  smarty cache
		//
		echo 'Checking cache permissions... ';
		$cacheDir = 'library/smarty/cache';
		if ( !is_writable($cacheDir) ) {
			echo 'not writeable, chmoding... ';
			system( 'chmod -R 777 "' . escapeshellarg($cacheDir) . '" ' );
		}
		echo "Ok!\n";

		//
		//  htaccess
		//
		echo 'Checking .htaccess file... ';
		$htaccessFile = 'htdocs/.htaccess';
		if ( !file_exists($htaccessFile) ) {
			echo 'not found, creating... ';
			copy( 'htdocs/htaccess', $htaccessFile );
		}
		echo "Ok!\n";

	}

	/**
	 *  performs an action on the database
	 *
	 *  @param String $cmd action to perform
	 *  @return nothing
	 *
	 */

	private function db( $cmd ) {

		switch ( $cmd ) {
			case 'build':
				echo "Rebuilding database:\n";
				$db = Smutty_Database::getInstance();
				$cfg = Smutty_Config::getInstance();
				$type = $cfg->get( 'db.type' );
				foreach ( array('drop','create','data') as $file ) {
					echo "Creating $file...";
					$path = "./application/schemas/$type/$file.sql";
					if ( file_exists($path) ) {
						$db->script( $path );
						echo "Done!\n";
					}
					else echo "$path not found...\n";
				}
				break;
			default:
				$this->usage();
		}

	}

	/**
	 *  this is the main entry point for running this
	 *  class from the command line
	 *
	 *  @param array $argv the command line arguments
	 *  @return nothing
	 *
	 */

	public function run( $argv ) {

		if ( file_exists('application/app.cfg') ) {
			$cfg =& Smutty_Config::getInstance();
			$cfg->loadDefaults();
		}

		$action = $argv[ 1 ];
		$name = $argv[ 2 ];

		switch ( $action ) {
			case 'controller':
				if ( !$name ) $this->usage();
				$this->createController( $name );
				break;
			case 'model':
				if ( !$name ) $this->usage();
				$this->createModel( $name );
				break;
			case 'test':
				if ( !$name ) $this->usage();
				$this->runTest( $name );
				break;
			case 'db':
				if ( !$name ) $this->usage();
				$this->db( $name );
				break;
			case 'setup':
				$this->setup();
				break;
			default:
				$this->usage();
		}

	}

}

?>