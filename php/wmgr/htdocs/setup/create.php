<?

chdir( '../../' );

include 'include/common.inc.php';
include 'libs/wmgr/Template.class.php';

Error::setFormat( Error::STP );

$type = $_POST['dbtype'];
$host = $_POST['dbhost'];
$user = $_POST['username'];
$pass = $_POST['password'];
$name = $_POST['dbname'];

// load the correct database driver
include "libs/wmgr/Database_$type.class.php";

// first check if we need to actually create the database
if ( $_POST['admin-username'] && $_POST['admin-password'] ) {

	$adUser = $_POST['admin-username'];
	$adPass = $_POST['admin-password'];

	$db = new Database();
	$db->connect( $host, $adUser, $adPass )
		|| Error::fatal( 'cannot connect as admin to database server' );

	// create database and user
	$db->create( $name, $user, $pass );

}

// then we can connect to the db and create all the
// objects and insert the default data
$db = new Database();
$db->connect( $host, $user, $pass, $name )
	|| Error::fatal( 'cannot connect to database' );
$db->runScript( "schema/$type/structure.sql" );
$db->runScript( "schema/$type/data.sql" );

// work out the URL_BASE
$url = $_SERVER['PHP_SELF'];
$urlbase = substr( $url, 0, strpos($url,'/setup/create.php') );

// write config file
$tpl = new Template();
$tpl->assign( 'URL_BASE', $urlbase );
$tpl->assign( 'DB_HOST', $host );
$tpl->assign( 'DB_USER', $user );
$tpl->assign( 'DB_PASS', $pass );
$tpl->assign( 'DB_NAME', $name );
$tpl->assign( 'DB_TYPE', 'DB_' . strtoupper($type) );
$f = fopen( 'config/settings.inc.php', 'w' );
fwrite( $f, $tpl->fetch('setup/settings.tpl') );
fclose( $f );

// tell the user they're all good to go!
$tpl = new Template();
$tpl->display( 'setup/complete.tpl' );

?>