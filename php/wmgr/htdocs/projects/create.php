<? 

chdir( '../../' );

include 'include/web.inc.php';

if ( $_POST['action'] == 'create-project' ) {

	// check required fields
	$required = array(
		name => array('project name',Data::STR),
		group => array('project groups',Data::INT)
	);
	Data::checkRequiredFields( $required, $_POST );

	// create the project
	$name = $_POST['name'];
	$group = $_POST['group'];
	$parent = $_POST['parent'];
	$project = Project::create( $name, $group, $parent );

	redirect( '/projects/view.php?id=' . $project->id );

}

else {

	$tpl = new Template();
	$tpl->display( 'projects/create.tpl' );

}

?>