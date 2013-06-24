<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];
$group = Group::load( $id );

$tpl = new Template();
$tpl->assign( 'group', $group );
$tpl->display( 'groups/pending.tpl' );

?>