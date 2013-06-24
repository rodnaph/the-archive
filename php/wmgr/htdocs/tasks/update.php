<?

chdir( '../../' );

include 'include/web.inc.php';

// check required fields
$required = array(
	id => array('task id',Data::INT),
	name => array('task name',Data::STR),
	type => array('task type',Data::INT),
	status => array('task status',Data::INT),
	priority => array('task priority',Data::INT),
	body => array('comments',Data::STR),
	project => array('project',Data::INT)
);
Data::checkRequiredFields( $required, $_POST );

// try and fetch task
if ( !$task = Task::load($_POST['id']) )
	Error::fatal( 'invalid task id' );

// then update it
$task->update(
	$_POST['name'],
	$_POST['status'],
	$_POST['type'],
	$_POST['priority'],
	$_POST['body'],
	$_POST['project']
);

// try and upload attachments if there are any
$project = Project::load( $task->project->id );
$docs = Document::uploadDocuments( $project->group->id, 'doc' );
if ( sizeof($docs) )
	$task->attachDocuments( $docs );

// then send user back to task
redirect( "/tasks/view.php?id=$task->id" );

?>
