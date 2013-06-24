<?php

/**
 *  this class is for templates used by the smutty
 *  framework itself.
 *
 */

class Smutty_Template_Smutty extends Smutty_Template {

	/**
	 *  constructor
	 *
	 *  @return nothing
	 *
	 */

	function __construct() {
		parent::__construct();
		$this->template_dir = 'library/smarty/templates';
		$this->compile_dir = 'library/smarty/cache/smutty';
		// need to keep a seperate compile dir to avoid
		// smarty wierdness i couldn't be bothered to look into.
		if ( !file_exists($this->compile_dir) )
			mkdir( $this->compile_dir );
	}

}

?>