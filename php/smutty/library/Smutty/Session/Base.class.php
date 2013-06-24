<?

Smutty_Main::loadClass( 'Smutty_Session_User' );

/**
 *  this class handles sessions within smutty.  it's basically
 *  just a wrapper around the $_SESSION object, and uses php's
 *  builtin session handling functions.
 *
 */

class Smutty_Session_Base {

	/**
	 *  initializes the session object, setting things
	 *  like cookie paths and handling a user
	 *
	 *  @return nothing
	 *
	 */

	function init() {

		// cookie setup
		ini_set( 'session.cookie_path', Smutty_Utils::getBaseUrl() . '/' );

		// start/restore the session
		// TODO:  for some reason this code is being reached
		// twice, but just checking seems to work...
		if ( !session_id() )
			session_start();

		// if there's no user logged in, try it
		if ( !$this->user )
			$this->tryAuth();

	}

	/**
	 *  returns the instance of the session class
	 *
	 *  @return Smutty_Session
	 *
	 */

	function &getInstance() {
		static $instance;
		if ( $instance == null ) {
			$instance = new Smutty_Session();
			$instance->init();
		}
		return $instance;
	}

	/**
	 *  tries to authenticate a user.  if the authentication succeeds
	 *  then the $user property will be set accordingly.
	 *
	 *  @return nothing
	 *
	 */

	function tryAuth() {

		Smutty_Main::loadClass(
			'Smutty_Session_Abstract', 'Smutty_Session_Standard'
		);

		$cfg = Smutty_Config::getInstance();

		switch ( $cfg->get('auth.type') ) {
			case 'standard':
				$this->user = Smutty_Session_Standard::getUser();
				break;
		}

	}

	/**
	 *  automagic method that handles setting properties
	 *
	 *  @param $name name of property
	 *  @param $value property value
	 *  @return true
	 *
	 */

	function __set( $name, &$value ) {
		$_SESSION[$name] = $value;
		return true;
	}

	/**
	 *  returns the value of a property.
	 *
	 *  @param $name name of property
	 *  @return property value
	 *
	 */

	function _getValue( $name ) {
		return v( $_SESSION, $name );
	}

}

?>