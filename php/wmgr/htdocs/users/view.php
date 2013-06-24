<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];
$dispUser = User::load( $id );

if ( !$dispUser )
	Error::fatal( 'you gave an invalid user id' );

$tpl = new Template();
$tpl->assign( 'dispUser', $dispUser );
$tpl->display( 'users/view.tpl' );

?>