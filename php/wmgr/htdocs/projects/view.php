<? 

chdir( '../../' );

include 'include/web.inc.php';

$id = Data::getInt( $_GET['id'] );
$project = Project::load( $id );

if ( !$project )
	Error::fatal( 'you either gave an invalid project id or you do not have permission to access that project' );

$tpl = new Template();
$tpl->assign( 'project', $project );
$tpl->display( 'projects/view.tpl' );

?>