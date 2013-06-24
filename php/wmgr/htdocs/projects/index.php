<?

chdir( '../../' );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'groups', $user->getGroups() );
$tpl->display( 'projects/index.tpl' );

?>