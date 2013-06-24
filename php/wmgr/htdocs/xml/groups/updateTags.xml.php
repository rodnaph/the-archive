<?

chdir( '../../../' );

include 'include/web.inc.php';

Error::setFormat( Error::XML );

$id = $_GET['id'];
$tagstring = $_GET['tags'];

// split tag string into array
$tags = split( ',', $tagstring );

// update group
$group = Group::load( $id );
$group->updateTags( $tags );

$tpl = new Template();
$tpl->assign( 'group', $group );
$tpl->display( 'xml/groups/viewTags.tpl' );

?>