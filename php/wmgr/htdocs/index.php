<?

chdir( '../' );

define( 'ANONYMOUS_OK', 1 );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'projectCount', Project::getTotal() );
$tpl->assign( 'groupCount', Group::getTotal() );
$tpl->assign( 'userCount', User::getTotal() );
$tpl->assign( 'pageCount', Page::getTotal() );
$tpl->display( 'index.tpl' );

?>