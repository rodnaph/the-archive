<?

chdir( '../../' );

include 'include/web.inc.php';

if ( $_POST['action'] == 'create-task' ) {

	$required = array(
		name => array('task name',Data::STR),
		project => array('task project',Data::INT),
		body => array('task description',Data::STR),
		priority => array('task priority',Data::INT),
		status => array('task status',Data::INT),
		type => array('task type',Data::INT)
	);
	Data::checkRequiredFields( $required, $_POST );

	// create the task
	$name = $_POST['name'];
	$body = $_POST['body'];
	$status = $_POST['status'];
	$priority = $_POST['priority'];
	$type = $_POST['type'];
	$projectID = $_POST['project'];

	$project = Project::load( $projectID );
	$task = Task::create( $name, $status, $type, $priority,
		$project->id, $body );

	// try and upload attachments if there are any
	$docs = Document::uploadDocuments( $project->group->id, 'doc' );
	if ( sizeof($docs) )
		$task->attachDocuments( $docs );

	redirect( '/tasks/view.php?id=' . $task->id );

}

else {

	$tpl = new Template();
	$tpl->assign( 'taskStatus', TaskStatus::fetchOpen() );
	$tpl->assign( 'taskTypes', TaskType::fetchAll() );
	$tpl->assign( 'taskPriorities', TaskPriority::fetchAll() );
	$tpl->display( 'tasks/create.tpl' );

}

?>