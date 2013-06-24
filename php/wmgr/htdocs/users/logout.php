<?

chdir( '../../' );

define( 'ANONYMOUS_OK', 1 );

include 'include/web.inc.php';

if ( $user )
	$user->logout();

redirect( '/users/login.php' );

?>