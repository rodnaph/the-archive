<?php

/**
 *  this is a utility class that provides a number of static
 *  method for doing various things within Smutty
 *
 */

class Smutty_Utils {

	/** the base url cache */
	private static $baseUrl = null;

	/**
	 *  returns the base URL for the appliation
	 *
	 *  @return String the application base url
	 *
	 */

	public static function getBaseUrl() {

		if ( self::$baseUrl == null ) {
			$data = Smutty_Data::getServerData();
			self::$baseUrl = substr( $data->string('PHP_SELF'), 0,
				strpos($data->string('PHP_SELF'), '/index.php') );
		}

		return self::$baseUrl;

	}

	/**
	 *  gets the url for a controller/action/etc...  it's assumed that
	 *  the controller is the current controller unless you specify
	 *  otherwise.
	 *
	 *  this tries to make the url extra pretty by stripping off anything
	 *  on the end of the url that isn't needed (default values, etc...)
	 *
	 *  @param array $params hash of params
	 *  @param array $args query string args
	 *  @return String the url
	 *
	 */

	public static function getUrl( $params, $args = false ) {

		$router = Smutty_Router::getInstance();
		// if a controller wan't specified then assume the
		// user meant to use the current controller.
		if ( !isset($params['controller']) )
			$params['controller'] = strtolower($router->getControllerName());

		$url = '';
		$spec = Smutty_Router::getRouteSpec(
			$params['controller'],
			v($params,'action')
		);

		$parts = array_reverse(explode( '/', $spec ));
		$valueAdded = false;
		foreach ( $parts as $name ) {

			switch ( $name ) {
				// strip default values for the special params
				// if we haven't added any values yet.
				case 'controller':
				case 'action':
					$value = v($params,$name);
					$defMethod = 'getDefault' . ucfirst($name) . 'Name';
					$default = $router->$defMethod();
					if ( $name == 'controller' ) {
						$default = strtolower( $default );
						$value = strtolower( $value );
					}
					if ( ($value == $default) && !$valueAdded )
						$value = '';
					break;
				default:
					$value = v($params,$name);
			}

			$url = $value . ( $valueAdded ? "/$url" : '' );
			if ( $value ) $valueAdded = true;

		}

		$url = Smutty_Utils::getBaseUrl() . '/' . preg_replace( '/\/\//', '/', $url );

		// now add any query string args we have
		if ( is_array($args) ) {
			$qs = '';
			foreach ( $args as $name => $value )
				$qs .= '&' . urlencode($name) . '=' . urlencode($value);
			$url .= ( $qs ? '?' . substr($qs,1) : '' );
		}

		return $url;

	}

	/**
	 *  this function is just like getUrl(), only it
	 *  includes the protocol://server:port part to.
	 *
	 *  @param array $params array of params
	 *  @return String base url with proto://domain:port/
	 *
	 */

	public static function getFullUrl( $params ) {

		$data = Smutty_Data::getServerData();
		$port = $data->string('SERVER_PORT');

		return 'http' .
			'://' .
			$data->string('SERVER_NAME') .
			( $port == '80' ? '' : ":$port" ) .
			Smutty_Utils::getUrl( $params );

	}

	/**
	 *  this function turns a commer seperated string
	 *  into a hash (associative array).  it treats the
	 *  string as having commer seperated values like...
	 *
	 *    name,value,name,value
	 *
	 *  @param String $str the string to convert
	 *  @return hash assoc array
	 *
	 */

	public static function strToHash( $str ) {

		$hash = array();
		$args = explode( ',', $str );
		$size = sizeof( $args );

		for ( $i=0; $i<$size; $i+=2 )
			if ( $args[$i] )
				$hash[ $args[$i] ] = $args[ $i + 1 ];

		return $hash;

	}

	/**
	 *  this function returns the smutty url (ie. with any base
	 *  url and query string stipped off)
	 *
	 *  @return String the url
	 *
	 */

	public static function getSmuttyUrl() {

		static $url;

		if ( $url == null ) {
			$data = Smutty_Data::getServerData();
			$baseUrl = Smutty_Utils::getBaseUrl();
			$url = substr( $data->string('REQUEST_URI'), strlen($baseUrl) + 1 );
			$url = preg_replace( '/^(.*)\?.*$/', '$1', $url );
		}

		return $url;

	}

	/**
	 *  returns a unique 10 char id string
	 *
	 *  @return String character string
	 *
	 */

	public static function getUniqueId() {
		$id = '';
		for ( $i=0; $i<10; $i++ )
			$id .= chr( rand(65,90) );
		return $id;
	}

	/**
	 *  computes the difference of arrays composed of objects
	 *
	 *  @param array $x main array
	 *  @param array $y array to comp against
	 *  @param String $p array index property
	 *  @return array the difference of arrays
	 *
	 */

	public static function arrayObjDiff( $x, $y, $p = 'id' ) {
		$z = array();
		$w = array();
		// build index
		foreach ( $y as $a )
			$w[$a->$p] = $a;
		// then compare
		foreach ( $x as $a )
			if ( !isset($w[$a->$p]) )
				$z[] = $a;
		return $z;
	}

}

?>