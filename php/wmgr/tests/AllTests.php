<?

chdir( '../' );

require_once 'PHPUnit/Framework.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once 'include/cli.inc.php';

require_once 'DatabaseTest.php';
require_once 'UserTest.php';
require_once 'DataTest.php';
require_once 'DocumentTest.php';
require_once 'GroupTest.php';
require_once 'GroupTagTest.php';
require_once 'IconTest.php';
require_once 'PageTest.php';
require_once 'PageHistoryTest.php';
require_once 'ProjectTest.php';
require_once 'TaskTest.php';
require_once 'TaskPriorityTest.php';
require_once 'TaskStatusTest.php';
require_once 'TaskTypeTest.php';

Error::setFormat( Error::CMD );

class AllTests {

	public function __construct() {}

	public static function main() {
		PHPUnit_TextUI_TestRunner::run(self::suite());
	}

	public static function suite() {

		global $db, $user;

		$db = new Database();
		$db->connect( DB_HOST, DB_USER, DB_PASS, DB_TEST_NAME );
		$user = User::load( 1 );

		$suite = new PHPUnit_Framework_TestSuite();
		$suite->addTestSuite('DatabaseTest');
		$suite->addTestSuite('UserTest');
		$suite->addTestSuite('DataTest');
		$suite->addTestSuite('DocumentTest');
		$suite->addTestSuite('GroupTest');
		$suite->addTestSuite('GroupTagTest');
		$suite->addTestSuite('IconTest');
		$suite->addTestSuite('PageTest');
		$suite->addTestSuite('PageHistoryTest');
		$suite->addTestSuite('ProjectTest');
		$suite->addTestSuite('TaskTest');
		$suite->addTestSuite('TaskPriorityTest');
		$suite->addTestSuite('TaskStatusTest');
		$suite->addTestSuite('TaskTypeTest');

		return $suite;

	}

}

?>