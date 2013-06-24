<?

chdir( '../../../../' );

include 'include/web.inc.php';

$id = Data::getInt($_GET['id']) ? Data::getInt($_GET['id']) : false;
$groupID = Data::getInt( $_GET['group_id'] );
$tpl = new Template();
$tpl->assign( 'children', Project::fetchChildren($id,$groupID) );
$tpl->display( 'xml/projects/explorer/getChildrenForProject.tpl' );

?>