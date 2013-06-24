<?php

/**
 *  represents a user currently authenticated with Smutty.  the "id"
 *  and "name" data comes from the authentication method, so can
 *  can be any number of things (eg. db auth would probably give the
 *  id a unique number, but gpg auth my give it a key id)
 *
 */

class Smutty_Session_User extends Smutty_Object {

	/** the users "id", which could be many formats */
	public $id;

	/** the users name */
	public $name;

	/** the users email */
	public $email;

	/**
	 *  constructor
	 *
	 *  @param int $id user id
	 *  @param String $name user name
	 *  @param String $email user email
	 *  @return nothing
	 *
	 */

	public function __construct( $id, $name, $email ) {
		$this->id = $id;
		$this->name = $name;
		$this->email = $email;
	}

}

?>