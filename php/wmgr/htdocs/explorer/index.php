<?

chdir( '../../' );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'provider', $_GET['provider'] );
$tpl->display( 'explorer/index.tpl' );

?>