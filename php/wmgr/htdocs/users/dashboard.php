<?

chdir( '../../' );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'latestGroups', Group::getLatest() );
$tpl->display( 'users/dashboard.tpl' );

?>