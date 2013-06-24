<?

require_once 'PHPUnit/Framework.php';

class PageTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		$user = User::load( 1 );
		$group = Group::create( 'MyGroup' . rand() );
		$dateEdited = time();
		$page = new Page( 1, 'MyPage', 'some text', $user, $group, $dateEdited, false );
		$this->assertEquals( $page->id, 1 );
		$this->assertEquals( $page->name, 'MyPage' );
		$this->assertEquals( $page->body, 'some text' );
		$this->assertEquals( $page->user, $user );
		$this->assertEquals( $page->group, $group );
		$this->assertEquals( $page->dateEdited, $dateEdited );
	}

	public function testGetBody() {
		$body = 'blah blah blah';
		$user = User::load( 1 );
		$group = Group::create( 'MyGroup' . rand() );
		$page = new Page( 1, 'MyPage', $body, $user, $group, time(), false );
		$this->assertEquals( $page->getBody(), $body );
	}

	public function testGetName() {
		$name = 'blah blah blah';
		$user = User::load( 1 );
		$group = Group::create( 'MyGroup' . rand() );
		$page = new Page( 1, $name, 'MyPage', $user, $group, time(), false );
		$this->assertEquals( $page->getName(), $name );
	}

	public function testCreate() {
		$group = Group::create( 'MyGroup' . rand() );
		$page = Page::create( 'MyPage', 'some text', $group->id );
		$this->assertTrue( $page ? true : false );
	}

	public function testUpdate() {
		$group = Group::create( 'MyGroup' . rand() );
		$newText = 'more text';
		$page = Page::create( 'MyPage', 'some text', $group->id );
		$page->update( $newText, 2 );
		$this->assertEquals( $page->getBody(), $newText );
	}

	public function testGetHistory() {
		$group = Group::create( 'MyGroup' . rand() );
		$page = Page::create( 'MyPage', 'some text', $group->id );
		$history = $page->getHistory();
		$this->assertTrue( is_array($history) );
	}

	public function testLoadByID() {
		$group = Group::create( 'MyGroup' . rand() );
		$page1 = Page::create( 'MyPage', 'some text', $group->id );
		$page2 = Page::loadByID( $page1->id );
		$this->assertEquals( $page1, $page2 );		
	}
	
	public function testLoadByName() {
		$group = Group::create( 'MyGroup' . rand() );
		$page1 = Page::create( 'MyPage', 'some text', $group->id );
		$page2 = Page::loadByName( $page1->name, $group->id );
		$this->assertEquals( $page1, $page2 );		
	}
	
	public function testGetTotal() {
		Page::getTotal();
	}

	public function testFetchChildren() {
		$this->assertTrue( is_array(Page::fetchChildren(false,false)) );
		$this->assertTrue( is_array(Page::fetchChildren(1,false)) );
		$this->assertTrue( is_array(Page::fetchChildren(false,1)) );
		$this->assertTrue( is_array(Page::fetchChildren(1,1)) );
	}
	
	public function testGetParentName() {
		$name = 'ParentName';
		$group = Group::create( 'MyGroup' . rand() );
		$page1 = Page::create( $name, 'body', $group->id );
		$page2 = Page::create( 'Child', 'body', $group->id, $page1->id );
		$this->assertEquals( $name, $page2->getParentName() );
	}

	public function testGetAncestors() {
		$group = Group::create( 'MyGroup' . rand() );
		$page1 = Page::create( 'parent', 'body', $group->id );
		$page2 = Page::create( 'Child', 'body', $group->id, $page1->id );
		$this->assertTrue( is_array($page2->getAncestors()) );
	}

	public function testDelete() {
		$group = Group::create( 'MyGroup' . rand() );
		$page = Page::create( 'name', 'body', $group->id );
		$pageID = $page->id;
		$page->delete();
		$this->assertFalse( Page::loadByID($pageID) );
	}

}

?>