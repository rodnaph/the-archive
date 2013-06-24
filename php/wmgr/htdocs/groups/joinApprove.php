<?

chdir( '../../' );

include 'include/web.inc.php';

$group = Group::load( $_GET['group_id'] );
$joinUser = User::load( $_GET['user_id'] );

// check we got a group
if ( !$group || !$user )
	Error::fatal( 'expected group or user not found', Error::SYS );

// check this user can do this
if ( !$group->isMember($user->id) )
	Error::fatal( 'you do not have permission to do that' );

$group->removePendingUser( $joinUser->id );
$group->addUser( $joinUser->id );

redirect( "/groups/pending.php?id=$group->id" );

?>