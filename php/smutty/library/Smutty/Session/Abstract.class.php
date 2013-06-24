<?php

/**
 *  this is the base class that Smutty authentication
 *  classes should implement.  it just defines one method
 *  which is getUser().  this method should try and authenticate
 *  a user, and return a Smutty_Session_User object if it succeeds.
 *
 */

abstract class Smutty_Session_Abstract extends Smutty_Object {

	/**
	 *  this function should do the work of authenticating the
	 *  user, and if they're valid return a Smutty_Session_User
	 *
	 *  NB!  i wanted to make this method abstract so it needs
	 *  to be implemented, but i read something about not being
	 *  able to override static methods, though it wasn't
	 *  certain, but it didn;t work for me.  hmmm...
	 *
	 *  @return Smutty_Session_User the current user
	 *
	 */

	public static function getUser() {}

}

?>