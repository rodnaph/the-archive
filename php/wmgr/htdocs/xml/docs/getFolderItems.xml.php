<?

chdir( '../../../' );

include 'include/web.inc.php';

Error::setFormat( Error::XML );

$folderID = Data::getInt( $_GET['folder_id'] );
$tpl = new Template();
$tpl->assign( 'items', Folder::getItems($folderID) );
$tpl->display( 'xml/docs/getFolderItems.tpl' );

?>