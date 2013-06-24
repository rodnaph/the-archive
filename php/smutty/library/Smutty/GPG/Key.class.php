<?php

/**
 *  represents a PGP key stored in the keyring
 *
 */

class Smutty_GPG_Key extends Smutty_Object {

	/** the keys pub value */
	private $pub;

	/** the keys uid value */
	private $uid;

	/** the keys sub value */
	private $sub;

	/**
	 *  constructor.
	 *
	 *  @param String $pub the pub value
	 *  @param String $uid the uid value
	 *  @param String $sub the sub value
	 *  @return nothing
	 *
	 */

	public function __construct( $pub, $uid, $sub ) {
		$this->pub = $pub;
		$this->uid = $uid;
		$this->sub = $sub;
	}

	/**
	 *  returns the pub data
	 *
	 *  @return String pub data
	 *
	 */

	public function getPub() {
		return $this->pub;
	}

	/**
	 *  returns the uid data
	 *
	 *  @return String uid data
	 *
	 */

	public function getUid() {
		return $this->uid;
	}

	/**
	 *  returns the sub data
	 *
	 *  @return String sub data
	 *
	 */

	public function getSub() {
		return $this->sub;
	}

}

?>