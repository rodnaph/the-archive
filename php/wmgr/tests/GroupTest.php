<?

require_once 'PHPUnit/Framework.php';

class GroupTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$group = new Group( 1, 'MyGroup' );
		$this->assertTrue( $group ? true : false );
	}

	public function testCreate() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$this->assertTrue( $group ? true : false );
		$this->assertNotNull( $group->id );
		$this->assertEquals( $name, $group->name );
	}

	public function testLoad() {
		$name = 'MyGroup' . rand();
		$group1 = Group::create( $name );
		$group2 = Group::load( $group1->id );
		$this->assertTrue( $group2 ? true : false );
		$this->assertEquals( $group1->id, $group2->id );
		$this->assertEquals( $group1->name, $group2->name );
	}

	public function testGetLatest() {
		$latest = Group::getLatest();
		$this->assertTrue( is_array($latest) );
	}
	
	public function testGetTotal() {
		Group::getTotal();
	}

	public function testGetProjects() {
		$groupName = 'MyGroup' . rand();
		$group = Group::create( $groupName );
		$projects = $group->getProjects();
		$this->assertTrue( is_array($projects) );
	}
	
	public function testGetLatestPages() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$pages = $group->getLatestPages();
		$this->assertTrue( is_array($pages) );
	}

	public function testIsPending() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->isPending( 1 );
	}

	public function testIsMember() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->isMember( 1 );
	}

	public function testGetPendingUsersCount() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->getPendingUsersCount();
	}

	public function testGetPendingUsers() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$users = $group->getPendingUsers();
		$this->assertTrue( is_array($users) );
	}

	public function testRemovePendingUser() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->removePendingUser( 1 );
	}

	public function testAddPendingUser() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->addPendingUser( 1 );
	}

	public function testAddUser() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$user = User::register( 'MyUser' . rand(), 'MyPass', 'email@nowhere.com' );
		$group->addUser( $user->id );
	}

	public function testUpdateTags() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$group->updateTags( array('qwe','rty') );
	}

	public function testGetTags() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$tags = $group->getTags();
		$this->assertTrue( is_array($tags) );
	}

	public function testGetUsers() {
		$name = 'MyGroup' . rand();
		$group = Group::create( $name );
		$users = $group->getUsers();
		$this->assertTrue( is_array($users) );
	}

}

?>