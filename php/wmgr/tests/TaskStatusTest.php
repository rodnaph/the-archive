<?

require_once 'PHPUnit/Framework.php';

class TaskStatusTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$icon = new Icon( 1, 'Name', 'file.png' );
		$p = new TaskStatus( 1, 'Name', 1, $icon );
		$this->assertEquals( $p->id, 1 );
		$this->assertEquals( $p->name, 'Name' );
		$this->assertEquals( $p->isClosed, 1 );
		$this->assertEquals( $p->icon, $icon );		
	}

	public function testFetchAll() {
		$all = TaskStatus::fetchAll();
		$this->assertTrue( is_array($all) );		
	}

}

?>