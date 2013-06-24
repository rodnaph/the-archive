<?

chdir( '../../' );

define( 'ANONYMOUS_OK', 1 );

include 'include/web.inc.php';

if ( $_POST['action'] == 'register' ) {

	// check required fields
	$required = array(
		user => array('name',Data::STR),
		pass => array('password',Data::STR),
		email => array('email',Data::STR)
	);
	Data::checkRequiredFields( $required, $_POST );

	// check passwords match
	if ( $_POST['pass'] != $_POST['pass2'] )
		Error::fatal( 'your passwords did not match' );

	// should be good to go!
	$name = $_POST['user'];
	$pass = $_POST['pass'];
	$email = $_POST['email'];

	// create the new user
	$newUser = User::register( $name, $pass, $email );

	// show the user success!
	$tpl = new Template();
	$tpl->assign( 'newUser', $newUser );
	$tpl->display( 'users/register-done.tpl' );

}

else {
	$tpl = new Template();
	$tpl->display( 'users/register.tpl' );
}

?>