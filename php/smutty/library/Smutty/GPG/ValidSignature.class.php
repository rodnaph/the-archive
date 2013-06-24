<?php

/**
 *  represents a valid GPG signature, provides a few methods for
 *  extracting information about the sig.
 *
 */

class Smutty_GPG_ValidSignature extends Smutty_Object {

	/** the signature text */
	private $text;

	/** owner of signature */
	private $name;

	/** sigs key id */
	private $keyId;

	/**
	 *  constructor.  the input should be an array of lines which
	 *  are the output of a successful attempt to verify a pgp sig.
	 *
	 *  @param array $results array of strings
	 *  @return nothing
	 *
	 */

	public function __construct( $results ) {

		$this->text = implode( "\n", $results );

		// contains names of properties, and a regexp
		// which will extract that prop from $results
		$props = array(
			'name' => '/signature from "(.+)"/',
			'keyId' => '/key ID ([A-Z0-9]+)/'
		);

		// extract properties from results
		foreach ( $props as $key => $regexp )
			foreach ( $results as $line )
				if ( preg_match($regexp,$line,$matches) )
					$this->$key = $matches[1];

	}

	/**
	 *  returns the complete text of the verify result
	 *
	 *  @return String message text
	 *
	 */

	public function getText() {
		return $this->text;
	}

	/**
	 *  returns the name associated with the sig
	 *
	 *  @return String user name
	 *
	 */

	public function getName() {
		return $this->name;
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

}

?>