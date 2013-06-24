<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];
$groupID = $_GET['group_id'];
$page = Page::loadByID( $id, $groupID );

if ( !$page )
	Error::fatal( 'you gave an invalid page id' );

$tpl = new Template();
$tpl->assign( 'page', $page );
$tpl->display( 'pages/history.tpl' );

?>