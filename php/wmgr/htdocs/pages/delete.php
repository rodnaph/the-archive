<?

chdir( '../../' );

include 'include/web.inc.php';

if ( $_POST['todo'] == 'delete-page' ) {

	if ( $page = Page::loadByID(Data::getInt($_POST['id'])) ) {
		$page->delete();
		$tpl = new Template();
		$tpl->display( 'pages/delete-complete.tpl' );
	}
	
	else Error::fatal( 'invalid page id' );
	
}

else {

	if ( $page = Page::loadByID(Data::getInt($_GET['id'])) ) {		
		$tpl = new Template();
		$tpl->assign( 'page', $page );
		$tpl->display( 'pages/delete.tpl' );
	}
	
	else Error::fatal( 'invalid page id' );

}

?>