<?php

/**
 *  this class handles sessions within smutty.  it's basically
 *  just a wrapper around the $_SESSION object, and uses php's
 *  builtin session handling functions.
 *
 */

class Smutty_Session extends Smutty_Object {

	/** the current user */
	public $user;

    // session data
    private $data;

    // smutty config
    private $cfg;

    public function __construct( $data, $cfg ) {
        
        $this->data = is_array($data) ? $data : array();
        $this->cfg = $cfg;
        
    }

	/**
	 *  initializes the session object, setting things
	 *  like cookie paths and handling a user
	 *
	 *  @return nothing
	 *
	 */

	public function init() {

		// cookie setup
		ini_set( 'session.cookie_path', Smutty_Utils::getBaseUrl() . '/' );

		// start/restore the session
		// TODO:  for some reason this code is being reached
		// twice, but just checking seems to work...
		if ( !session_id() )
			session_start();

		// reload data from session
		foreach ( $this->data as $key => $value )
			$this->$key = $value;

		// if there's no user logged in, try it
		if ( !$this->user )
			$this->tryAuth();

	}

	/**
	 *  returns the instance of the session class
	 *
	 *  @return Smutty_Session the singleton
	 *
	 */

	public static function &getInstance() {

		singlemess();

	}

	/**
	 *  tries to authenticate a user.  if the authentication succeeds
	 *  then the $user property will be set accordingly.
	 *
	 *  @return nothing
	 *
	 */

	private function tryAuth() {

		switch ( $this->cfg->get('auth.type') ) {
			case 'standard':
				$this->user = Smutty_Session_Standard::getUser();
				break;
		}

	}

	/**
	 *  saves the data to the session object
	 *
	 *  @return nothing
	 *
	 */

	public function save() {

		foreach( $this as $key => $value ) {
			$this->data[$key] = $value;
        }

	}

}
