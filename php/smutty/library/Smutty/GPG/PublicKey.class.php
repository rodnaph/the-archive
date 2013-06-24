<?php

/**
 *  represents a GPG public key
 *
 */

class Smutty_GPG_PublicKey extends Smutty_Object {

	/** the name of the keys owner */
	private $name;

	/** the keys id */
	private $keyId;

	/**
	 *  constructor.  this takes an array of lines that were
	 *  output by the gpg program when validating the key.
	 *  they are then parsed to find the key info.
	 *
	 *  @param array $results array of lines
	 *  @return nothing
	 *
	 */

	public function __construct( $results ) {

		// contains names of properties, and a regexp
		// which will extract that prop from $results
		$props = array(
			'name' => '/: "(.+)" /',
			'keyId' => '/key ([A-Z0-9]+):/'
		);

		// extract properties from results
		foreach ( $props as $key => $regexp )
			foreach ( $results as $line )
				if ( preg_match($regexp,$line,$matches) )
					$this->$key = $matches[1];

	}

	/**
	 *  returns the keys id
	 *
	 *  @return String key id
	 *
	 */

	public function getKeyId() {
		return $this->keyId;
	}

	/**
	 *  returns name associated with key
	 *
	 *  @return String user name
	 *
	 */

	public function getName() {
		return $this->name;
	}

}

?>