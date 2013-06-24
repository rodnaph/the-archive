<?

/**
 *  redirects a user to the url which is absolute to the
 *  sites base.
 *
 *  eg.  /users/login.php would redirect to /~rod/apps/wmgr/users/login.php
 *  if the app is located at /~rod/apps/wmgr.
 *
 *  @param [url] the url to redirect to
 *
 */

function redirect( $url ) {

	header( 'Location: ' . URL_BASE . $url );
	exit();

}

include 'common.inc.php';

// check for settings file
if ( file_exists('config/settings.inc.php') )
	include 'config/settings.inc.php';
else {
	header( 'Location: setup/' );
	exit();
}

ini_set( 'session.cookie_path', URL_BASE );

// connect to the database
$db = new Database();
if ( !$db->connect(DB_HOST,DB_USER,DB_PASS,DB_NAME) )
	Error::fatal( 'could not connect to database: ' . $db->getError(), Error::SYS );

// check authentication
$user = User::restoreSession();
if ( !$user && !defined('ANONYMOUS_OK') ) {
	$return =  urlencode( $_SERVER['PHP_SELF'] .
		($_SERVER['QUERY_STRING'] ? '?' . $_SERVER['QUERY_STRING'] : '') );
	redirect( "/users/login.php?return=$return" );
}

?>