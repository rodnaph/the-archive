<?

chdir( '../../' );

include 'include/web.inc.php';

// are we editing an existing page?
if ( $_POST['action'] == 'edit-page' ) {

	$id = $_POST['id'];
	$body = $_POST['body'];
	$groups = $_POST['group'];

	// check required fields
	$required = array(
		id => array('page id',Data::INT),
		body => array('page body',Data::STR)
	);
	Data::checkRequiredFields( $required, $_POST );

	// try and load the page
	$groupID = $_POST['group_id'];
	if ( !$page = Page::loadByID($id,$groupID) )
		Error::fatal( 'the page could not be loaded' );
	$parent = Data::getInt( $_POST['parent'] );

	$page->update( $body, $parent );

	// then send the user to the created page
	$return = '/pages/view.php?id=' . $page->id . '&group_id=' . $page->group->id;
	if ( $_POST['return'] )
		$return = $_POST['return'];
	redirect( $return );

}

// creating a new page
elseif ( $_POST['action'] == 'create-page' ) {

	// check required fields
	$required = array(
		name => array('page name',Data::STR),
		body => array('page body',Data::STR),
		group_id => array('page group',Data::INT)
	);
	Data::checkRequiredFields( $required, $_POST );

	// check for name clash
	$groupID = $_POST['group_id'];
	if ( Page::loadByName($_POST['name'],$groupID) )
		Error::fatal( 'that page name already exists' );

	// should be all good
	$name = $_POST['name'];
	$body = $_POST['body'];
	$parent = $_POST['parent'];

	$page = Page::create( $name, $body, $groupID, $parent );

	// then send the user to the created page
	redirect( '/pages/view.php?id=' . $page->id . '&group_id=' . $page->group->id );

}

// or displaying a page for editing/creating
else {

	$id = $_GET['id'];
	$name = $_GET['name'];
	$groupID = $_GET['group_id'];
	$parentID = Data::getInt( $_GET['parent_id'] );
	$page = Page::loadByID( $id );
	$parent = Page::loadByID( $parentID );
	
	$tpl = new Template();
	$tpl->assign( 'pageName', $name );
	$tpl->assign( 'parent', $parent );
	if ( !$parent )
		$tpl->assign( 'parentName', $page ? $page->getParentName() : '' );
	$tpl->assign( 'groupID',$page ? $page->group->id : $groupID );
	$tpl->assign( 'page', $page );
	$tpl->display( 'pages/edit.tpl' );

}

?>