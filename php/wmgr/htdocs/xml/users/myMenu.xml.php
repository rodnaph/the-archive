<?

chdir( '../../../' );

include 'include/web.inc.php';

Error::setFormat( Error::XML );

$tpl = new Template();
$tpl->display( 'xml/users/myMenu.tpl' );

?>