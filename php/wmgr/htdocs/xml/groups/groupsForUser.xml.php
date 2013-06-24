<?

chdir( '../../../' );

include 'include/web.inc.php';

Error::setFormat( Error::XML );

$tpl = new Template();
$tpl->display( 'xml/groups/groupsForUser.tpl' );

?>