<?

chdir( '../../' );

define( 'ANONYMOUS_OK', 1 );

include 'include/web.inc.php';

// try a login?
if ( $_POST['action'] == 'login' ) {

	$name = $_POST['user'];
	$pass = $_POST['pass'];

	$user = User::login( $name, $pass );

}

// if we have a user then redirect them somewhere...
if ( $user ) {
	$url = $_POST['return']
		? $_POST['return']
		: '/users/dashboard.php';
	if ( substr($url,0,strlen(URL_BASE)) == URL_BASE )
		$url = substr( $url, strlen(URL_BASE) );
	redirect( $url );
}

$tpl = new Template();
$tpl->display( 'users/login.tpl' );

?>