<?

require_once 'PHPUnit/Framework.php';

class DataTest extends PHPUnit_Framework_TestCase {

	public function testGetInt() {
		$this->assertEquals( Data::getInt('9'), '9' );
		$this->assertNotEquals( Data::getInt('asd'), 'asd' );
	}

}

?>