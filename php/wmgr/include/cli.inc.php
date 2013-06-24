<?

include 'common.inc.php';
include 'config/settings.inc.php';

Error::setFormat( Error::CMD );

// connect to the database
$db = new Database();
if ( !$db->connect(DB_HOST,DB_USER,DB_PASS,DB_NAME) )
	Error::fatal( 'could not connect to database: ' . $db->getError(), Error::SYS );

?>