<?

chdir( '../../' );

include 'include/cli.inc.php';

$db = new Database();
$db->connect( DB_HOST, DB_ADMIN_USER, DB_ADMIN_PASS )
	|| Error::fatal( $db->getError(), Error::SYS );

// drop current test database, and then create a new one
$db->drop( DB_TEST_NAME );
$db->create( DB_TEST_NAME, DB_USER, DB_PASS );
$db->disconnect();

// connect to newly created test db and set it up
$db->connect( DB_HOST, DB_USER, DB_PASS, DB_TEST_NAME )
	|| Error::fatal( $db->getError(), Error::SYS );
$db->runScript( 'schema/' . DB_TYPE . '/structure.sql' );
$db->runScript( 'schema/' . DB_TYPE . '/data.sql' );

// then run the test suite
chdir( 'tests' );
system( 'phpunit --verbose AllTests.php' );

?>