<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];
$group = Group::load( $id );

// check we got a group
if ( !$group )
	Error::fatal( 'expected group not found', Error::SYS );

$group->addPendingUser( $user->id );

redirect( "/groups/view.php?id=$group->id" );

?>