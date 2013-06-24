<?php

/**
 *  a class for authenticating users by "standard" database
 *  user/pass authentication.  the fields can be customized
 *  by various values in your app.cfg
 *
 *  auth.standard.nameParam = form name param name
 *  auth.standard.passParam = form pass param name
 *  auth.standard.table = user table name
 *  auth.standard.idField = user table id field name
 *  auth.standard.nameField = user name field name
 *  auth.standard.passField = user pass field name
 *  auth.standard.passType = md5/plaintext
 *  auth.standard.emailField = user email field name
 *
 */

class Smutty_Session_Standard extends Smutty_Session_Abstract {

	/**
	 *  this function tries to authenticate a user by
	 *  standard username/password auth.  if it works then
	 *  it'll return a new Smutty_Session_User object,
	 *  otherwise it'll return false.
	 *
	 *  @return Smutty_Session_User the current user
	 *
	 */

	public static function getUser() {

		$data = Smutty_Data::getInstance();
		$cfg = Smutty_Config::getInstance();

		// get args
		$nameParam = $cfg->get('auth.standard.nameParam') ? $cfg->get('auth.standard.nameParam') : 'username';
		$passParam = $cfg->get('auth.standard.passParam') ? $cfg->get('auth.standard.passParam') : 'password';
		$name = $data->string( $nameParam );
		$pass = $data->string( $passParam );

		// if we don't have a username and password
		// then there's really no point in going on
		// (blank passwords?)
		if ( !$name || !$pass ) return false;

		$db = Smutty_Database::getInstance();

		// set correct table/field names
		$table = $cfg->get('auth.standard.table') ? $cfg->get('auth.standard.table') : 'users';
		$idField = $cfg->get('auth.standard.idField') ? $cfg->get('auth.standard.idField') : 'id';
		$nameField = $cfg->get('auth.standard.nameField') ? $cfg->get('auth.standard.nameField') : 'username';
		$passField = $cfg->get('auth.standard.passField') ? $cfg->get('auth.standard.passField') : 'password';

		// the email field is optional and needs to be explicitly
		// set in the config if it's gonna be used.
		$emailSql = " '' as email, ";
		if ( $emailFld = $cfg->get('auth.standard.emailField') )
			$emailSql = " u.`$emailFld` as email, ";

		// do the query
		$sql = " select
					u.`$idField` as id,
					u.`$nameField` as name,
					$emailSql
					u.`$passField` as pass
				from `$table` u
				where u.`$nameField` = '$name'
				limit 1 ";
		if ( !$res = $db->query($sql) )
			Smutty_Error::fatal( $db->getError(), 'ClassSmutty_Database' );

		// if we have a row, check the password
		$isValid = false;
		if ( $row = $res->fetchObject() )
			switch( $cfg->get('auth.standard.passType') ) {
				// plaintext password
				case 'plaintext':
					$isValid = ( $row->pass == $pass );
					break;
				// default is md5 hash
				default:
					$isValid = ( $row->pass == md5($pass) );
			}
		return $isValid
			? self::createUser(array(
				'id' => $row->id,
				'name' => $row->name,
				'email' => $row->email ))
			: false;

	}

	/**
	 *  checks to see if there's a 'User' class to use
	 *  for the user object, otherwise it uses the standard
	 *  user session object
	 *
	 *  @param array $hash assoc array of args
	 *  @return User the user object
	 *
	 */

	private static function createUser( $hash ) {

		$user = null;

		if ( class_exists('User') )
			$user = User::find( $hash['id'] );
		else
			$user = new Smutty_Session_User(
				v( $hash, 'id' ),
				v( $hash, 'name' ),
				v( $hash, 'email' )
			);

		return $user;

	}

}

?>