<?

include 'libs/smarty/Smarty.class.php';

class Template extends Smarty {

	/**
	 *  constructor of the Template object
	 *
	 */

	public function __construct() {

		global $user;

		// smarty customization
		$this->template_dir = './templates/';
		$this->plugins_dir[] = './templates/include/plugins';

		// we'd like to use our own directory for compiling templates, but
		// if this isn't writable (like it may not be when running setup) we'll
		// hafta take whatever we can get.
		$compileDir = './cache/smarty/';
		if ( is_writable($compileDir) )
			$this->compile_dir = $compileDir;
		else {
			$this->compile_dir = '/tmp';
			Error::addWarning( 'cache directory is not writable, using /tmp', Error::SYS );
		}

		// add default variables
		$this->assign( 'URL_BASE', URL_BASE );
		$this->assign( 'user', $user );

	}

}

?>