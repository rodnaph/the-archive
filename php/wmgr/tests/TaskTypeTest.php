<?

require_once 'PHPUnit/Framework.php';

class TaskTypeTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$icon = new Icon( 1, 'Name', 'file.png' );
		$p = new TaskType( 1, 'Name', $icon );
		$this->assertEquals( $p->id, 1 );
		$this->assertEquals( $p->name, 'Name' );
		$this->assertEquals( $p->icon, $icon );		
	}

	public function testFetchAll() {
		$all = TaskType::fetchAll();
		$this->assertTrue( is_array($all) );		
	}

}

?>