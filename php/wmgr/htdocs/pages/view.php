<?

chdir( '../../' );

include 'include/web.inc.php';

$id = $_GET['id'];
$name = $_GET['name'];
$groupID = $_GET['group_id'];

// try and load the page
if ( $id )
	$page = Page::loadByID( $id, $groupID );
elseif ( $name )
	$page = Page::loadByName( $name, $groupID );

if ( !$page )
	redirect( '/pages/edit.php?name=' . urlencode($name) .
				'&group_id=' . urlencode($groupID) .
				'&parent_id=' . urlencode(Data::getInt($_GET['from'])) );

$tpl = new Template();
$tpl->assign( 'page', $page );
$tpl->assign( 'children', $page ? Page::fetchChildren($page->id,false) : array() );
$tpl->display( 'pages/view.tpl' );

?>