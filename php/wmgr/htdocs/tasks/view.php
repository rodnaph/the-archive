<?

chdir( '../../' );

include 'include/web.inc.php';

$task = Task::load( Data::getInt($_GET['id']) );

$tpl = new Template();
$tpl->assign( 'task', $task );
$tpl->assign( 'taskStatus', TaskStatus::fetchAll() );
$tpl->assign( 'taskTypes', TaskType::fetchAll() );
$tpl->assign( 'taskPriorities', TaskPriority::fetchAll() );
$tpl->display( 'tasks/view.tpl' );

?>
