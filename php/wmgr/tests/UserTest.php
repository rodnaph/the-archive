<?

require_once 'PHPUnit/Framework.php';

class UserTest extends PHPUnit_Framework_TestCase {

	public function testGetGroups() {
		global $user;
		$groups = $user->getGroups();
	}

	public function testGetProjects() {
		global $user;
		$projects = $user->getProjects();
	}
	
	public function testGetTasks() {
		global $user;
		$user->getTasks();
	}
	
	public function testGetLatestTasks() {
		global $user;
		$user->getLatestTasks();
	}

	public function testGetTotal() {
		global $db;
		User::getTotal();
	}
	
	public function testRegister() {
	}

	public function testGetPages() {
		global $user;
		$array = $user->getPages();
		$this->assertTrue( is_array($array) );
	}

}

?>