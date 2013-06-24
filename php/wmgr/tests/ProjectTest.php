<?

require_once 'PHPUnit/Framework.php';

class ProjectTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$id = 1;
		$name = 'MyProject';
		$group = new Group( 1, 'MyGroup' );
		$proj = new Project( $id, $name, $group );
		$this->assertTrue( $proj ? true : false );
		$this->assertEquals( $proj->id, $id );
		$this->assertEquals( $proj->name, $name );
	}

	public function testCreate() {
		$group = Group::create( 'MyGroup' . rand() );
		$name = 'MyProject' . rand();
		$proj = Project::create( $name, $group->id, false );
		$this->assertTrue( $proj ? true : false );
		$this->assertEquals( $proj->name, $name );
	}

	public function testLoad() {
		$group = Group::create( 'MyGroup' . rand() );
		$name = 'MyProject' . rand();
		$proj1 = Project::create( $name, $group->id, false );
		$proj2 = Project::load( $proj1->id );
		$this->assertTrue( $proj2 ? true : false );
		$this->assertEquals( $proj1, $proj2 );
	}

	public function testGetTotal() {
		Project::getTotal();
	}

	public function testFetchChildren() {
		// no args
		$children = Project::fetchChildren( false, false );
		$this->assertTrue( is_array($children) );
		// id arg
		$children = Project::fetchChildren( 1, false );
		$this->assertTrue( is_array($children) );
		// group arg
		$children = Project::fetchChildren( false, 1 );
		$this->assertTrue( is_array($children) );
		// both args
		$children = Project::fetchChildren( 1, 1 );
		$this->assertTrue( is_array($children) );
	}

	public function testGetAncestors() {
		$group = Group::create( 'MyGroup' . rand() );
		$proj = Project::create( 'MyProj' . rand(), $group->id, false );
		$ancestors = $proj->getAncestors();
		$this->assertTrue( is_array($ancestors) );		
	}
	
	public function getPage() {
		$group = Group::create( 'MyGroup' . rand() );
		$proj = Project::create( 'MyProj' . rand(), $group->id, false );
		$proj->getPage();	
	}
	
	public function setPage() {
		$group = Group::create( 'MyGroup' . rand() );
		$proj = Project::create( 'MyProj' . rand(), $group->id, false );
		$page = Page::create( 'MyPage', 'body', $group->id );
		$proj->setPage( $page->id );
	}
	
}

?>