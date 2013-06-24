<?

require_once 'PHPUnit/Framework.php';

class GroupTagTest extends PHPUnit_Framework_TestCase {
	
	public function testConstructor() {
		$tag = new GroupTag( 1, 'MyTag' );
	}

}

?>