<?php

/**
 *  this class creates allows access to config files in
 *  an easy way.  normally for Smutty a singleton instance
 *  is maintained (accessed through getInstance())
 *
 *  @see getInstance()
 *
 */

class Smutty_Config extends Smutty_Object {

	/** data store */
	private $data;

	/** get cache */
	private $getCache;

	/**
	 *  constructor.  creates a new config class.
	 *
	 *  @return nothing
	 *
	 */

	public function __construct() {

		$this->data = array();
		$this->getCache = array();

	}

	/**
	 *  loads the config with data from the specified file.  this will
	 *  not overwrite any data, so it can be called multiple times
	 *  to load data from multiple config files.
	 *
	 *  @param String $path path to file to load
	 *  @return nothing
	 *
	 */

	public function loadConfig( $path ) {

		if ( !$f = @fopen($path,'r') ) {
			throw new Smutty_Error( 'config file not found: ' . $path, 'SmuttyConfig', Smutty_Error::FATAL );
        }

		while ( $line = fgets($f) ) {
			$this->loadLine( $line );
        }

		fclose( $f );

	}

	/**
	 *  this function loads the default config files
	 *
	 *  @return nothing
	 *
	 */

	public function loadDefaults() {

		$this->loadConfig( 'library/smutty.cfg' );
		$this->loadConfig( 'application/app.cfg' );

	}

	/**
	 *  processes a single line of configuration info
	 *
	 *  @param String $line the line to parse
	 *  @return nothing
	 *
	 */

	public function loadLine( $line ) {

		if ( $line[0] == '#' ) {
			return; // skip comments
        }

		// break the line into name and value
		preg_match( '/^([\w_\.]*\*{0,1})\s*=\s*([\d\w\/_ ,]*)\s*/', $line, $matches );

		if ( $matches ) {
			$name = trim( $matches[1] );
			$value = trim( $matches[2] );
			if ( $name && $value ) {
				$this->data[ $name ] = $value;
            }
		}

	}

	/**
	 *  looks for a config setting matching the given
	 *  name.  you can use a "*" as a wildcard
	 *
	 *  @param String $name setting name
	 *  @return String the config value
	 *
	 */

	public function get( $name ) {

		// check for an exact match
		if ( isset($this->data[$name]) ) {
			return $this->data[$name];
        }

		// cache hit?
		elseif ( isset($this->getCache[$name]) ) {
			return $this->getCache[$name];
        }

		// are we looking to for multiple matches?
		elseif ( strpos($name,'*') ) {
            $vars = array();
            $regexp = $this->getWildcardRegExp( $name );
            foreach ( $this->data as $key => $value ) {
                if ( preg_match($regexp,$key) ) {
                    $vars[ $key ] = $value;
                }
            }
            $this->getCache[$name] = $vars;
            return $vars;
        }

		// lastly, check for wildcards in the spec
		// eg. route.ctlr.prefix* = whatever
		else foreach ( $this->data as $key => $value ) {
			if ( strpos($key,'*') ) {
				$regexp = $this->getWildcardRegExp( $key );
				if ( preg_match($regexp,$name) ) {
					$this->getCache[$name] = $value;
					return $value;
				}
			}
        }

		$this->getCache[$name] = '';

		return '';

	}

	/**
	 *  converts a string into a regexp where wildcards (*'s)
	 *  will be matched in it.
	 *
	 *  @param String $name the string to convert
	 *  @return String the regexp
	 *
	 */

	private function getWildcardRegExp( $name ) {

		$regexp = '/^' . str_replace('.','\\.',$name) . '$/';
		$regexp = str_replace( '*','.*', $regexp );

		return $regexp;

	}

	/**
	 *  returns the singleton for this object
	 *
	 *  @return Smutty_Config the singleton
	 *
	 */

	public static function &getInstance() {

        singlemess();
        
	}

}
