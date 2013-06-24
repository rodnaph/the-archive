<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];

if ( $group = Group::load($id) ) {

	$tpl = new Template();
	$tpl->assign( 'group', $group );
	$tpl->display( 'groups/view.tpl' );

}

else Error::fatal( 'the group was not found' );

?>