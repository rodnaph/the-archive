<?

chdir( '../../' );

if ( file_exists('config/settings.inc.php') ) {
	$tpl = new Template();
	$tpl->display( 'setup/index-exists.tpl' );
	exit();
}

include 'include/common.inc.php';
include 'libs/wmgr/Template.class.php';

Error::setFormat( Error::STP );

$tpl = new Template();
$tpl->assign( 'DB_MYSQL', DB_MYSQL );
$tpl->assign( 'DB_MSSQL', DB_MSSQL );
$tpl->assign( 'configWritable', is_writable('config/') );
$tpl->assign( 'cacheWritable', is_writable('cache/') );
$tpl->display( 'setup/index.tpl' );

?>
