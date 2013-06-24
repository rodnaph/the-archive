<?

chdir( '../../' );

include 'include/web.inc.php';

$tpl = new Template();
$tpl->assign( 'TYPE_FOLDER', FolderItem::FOLDER );
$tpl->assign( 'TYPE_FILE', FolderItem::FILE );
$tpl->assign( 'folderID', Data::getInt($_GET['folder_id']) );
$tpl->display( 'docs/index.tpl' );

?>
