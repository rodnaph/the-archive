<?

chdir( '../../' );

include 'include/web.inc.php';

if ( $_POST['action'] == 'create-group' ) {

	// check for required fields
	$required = array(
		name => array('group name',Data::STR)
	);
	Data::checkRequiredFields( $required, $_POST );

	// should be good to go!
	$name = $_POST['name'];
	$group = Group::create( $name );

	redirect( "/groups/view.php?id=$group->id" );

}

else {

	$tpl = new Template();
	$tpl->display( 'groups/create.tpl' );

}

?>