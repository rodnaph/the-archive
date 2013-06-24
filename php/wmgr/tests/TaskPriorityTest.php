<?

require_once 'PHPUnit/Framework.php';

class TaskPriorityTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$icon = new Icon( 1, 'Name', 'file.png' );
		$p = new TaskPriority( 1, 'Name', $icon );
		$this->assertEquals( $p->id, 1 );
		$this->assertEquals( $p->name, 'Name' );
		$this->assertEquals( $p->icon, $icon );		
	}

	public function testFetchAll() {
		$all = TaskPriority::fetchAll();
		$this->assertTrue( is_array($all) );		
	}

}

?>