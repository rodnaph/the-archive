<?

chdir( '../../' );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'pages', $user->getPages() );
$tpl->display( 'pages/index.tpl' );

?>