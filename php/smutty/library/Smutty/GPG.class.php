<?php

/**
 *  this class provides some functions for dealing with the
 *  gpg keyring (if there is one).
 *
 *  unless otherwise specified, it will create it's own keyring
 *  directory in the application folder.
 *
 */

class Smutty_GPG extends Smutty_Object {

	/** path to gpg binary */
	private $bin;

	/** command to execute gpg */
	private $gpg;

	/** gpg keyring dir */
	private $homedir;

	/** singleton */
	private static $instance;

	/**
	 *  constructor.  makes sure everything is set up ok.  creates
	 *  the keyring directory if it doesn't exist.
	 *
	 *  @return nothing
	 *
	 */

	function __construct( $homedir = false ) {

		$this->homedir = $homedir ? $homedir : 'application/data/gpg';
		$this->bin = '/usr/bin/gpg';
		$this->gpg = " $this->bin --homedir " . escapeshellarg($this->homedir) . " 2>&1 ";

		// check required keyring dir exists
		if ( !file_exists($this->homedir) )
			if ( !mkdir($this->homedir) )
				Smutty_Error::fatal( 'cannot create directory data/gpg', 'ClassSmutty_PGP' );

		// check we can write to keyring dir
		if ( !is_writable($this->homedir) )
			Smutty_Error::fatal( 'data/gpg is not writable', 'ClassSmutty_GPG' );

	}

	/**
	 *  returns the singleton instance of this class
	 *
	 *  @return Smutty_GPG the singleton
	 *
	 */

	public static function &getInstance() {
		if ( self::$instance == null )
			self::$instance = new Smutty_GPG();
		return self::$instance;
	}

	/**
	 *  verifies a signature with the keyring.  if the sig is valid
	 *  then it'll return a Smutty_GPG_ValidSignature object with all
	 *  the info about the sig.  otherwise it'll return false.
	 *
	 *  @param String $sig the signature to verify
	 *  @return Smutty_GPG_ValidSignature a valid sig object
	 *
	 */

	public function verify( $sig ) {
		$sig = escapeshellarg( $sig );
		exec( "echo $sig | $this->gpg --verify ", $result );
		// look for success
		foreach ( $result as $line )
			if ( preg_match('/Good signature from "(.*)"/',$line,$matches) )
				return new Smutty_GPG_ValidSignature( $result );
		return false;
	}

	/**
	 *  imports a public key into the keyring.  returns a
	 *  boolean indicating if it went ok or not.
	 *
	 *  @param String $key the public key to import
	 *  @return Smutty_GPG_PublicKey the imported key
	 *
	 */

	public function import( $key ) {
		$key = escapeshellarg( $key );
		exec( "echo $key | $this->gpg --import ", $result );
		// check for success
		foreach ( $result as $line )
			if ( preg_match('/key .* [imported|not changed]/',$line) )
				return new Smutty_GPG_PublicKey( $result );
		return false;
	}

	/**
	 *  lists the keys in the keyring.  returns an array
	 *  of Smutty_GPG_Key objects.
	 *
	 *  @return array Smutty_GPG_Key's
	 *
	 */

	public function listKeys() {

		$keys = array();
		exec( " $this->gpg --list-keys ", $result );

		// remove info lines
		while ( $line = array_shift($result) )
			if ( preg_match('/^-----/',$line) )
				break;

		while ( $result ) {
			$pub = substr( array_shift($result), 6 );
			$uid = substr( array_shift($result), 6 );
			$sub = substr( array_shift($result), 6 );
			array_shift( $result ); // blank line
			array_push( $keys, new Smutty_GPG_Key(
				$pub, $uid, $sub
			));
		}

		return $keys;

	}

}

?>