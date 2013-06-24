<?

require_once 'PHPUnit/Framework.php';

class TaskTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {

		$id = 1;
		$name = 'MyTask';
		$creator = new User( 1, 'Name', 'email@somewhere.com' );
		$status = new TaskStatus( 1, 'MyStatus', 0 );
		$type = new TaskType( 1, 'MyType' );
		$priority = new TaskPriority( 1, 'MyPriority' );
		$desc = 'my task';
		$date = time();
		$histID = 1;
		$project = new Project( 1, 'MyProject', new Group(1,'Mine') );
		
		$task = new Task( $id, $name, $creator, $status, $type, $priority, $desc, $date, $histID, $project );
		
		$this->assertTrue( $task ? true : false );
		$this->assertEquals( $task->id, $id );		
		$this->assertEquals( $task->name, $name );		
		$this->assertEquals( $task->creator, $creator );		
		$this->assertEquals( $task->status, $status );		
		$this->assertEquals( $task->type, $type );		
		$this->assertEquals( $task->priority, $priority );		
		$this->assertEquals( $task->description, $desc );		
		$this->assertEquals( $task->dateCreated, $date );		
		$this->assertEquals( $task->historyID, $histID );
		$this->assertEquals( $task->project, $project );

	}
	
	public function testCreate() {
		$task = TaskTest::getNewTask();
		$this->assertTrue( $task ? true : false );
	}

	public function testAddUser() {
		$user = User::register( 'MyUser' . rand(), 'pass', 'email@nowhere.com' );
		$task = TaskTest::getNewTask();
		$task->addUser( $user->id );
	}

	public function testUpdate() {
		$task = TaskTest::getNewTask();
		$task->update( 'new name', 2, 2, 2, 'what eva', 1 );
		$task2 = Task::load( $task->id );
		$this->assertEquals( $task2->name, 'new name' );
		$this->assertEquals( $task2->status->id, 2 );
		$this->assertEquals( $task2->type->id, 2 );
		$this->assertEquals( $task2->priority->id, 2 );
	}

	public function testGetHistory() {
		$task = TaskTest::getNewTask();
		$history = $task->getHistory();
		$this->assertTrue( is_array($history) );
	}

	public function testAddDocument() {
		$task = TaskTest::getNewTask();
		$task->addDocument(new Document(
			1, 'MyDoc', new User(1,'Name','email@nowhere'),
			time(), 1, 'text/plain'
		));
	}
	
	public function testGetDocuments() {
		$task = TaskTest::getNewTask();
		$docs = $task->getDocuments();
		$this->assertTrue( is_array($docs) );
	}

	public function testAttachDocuments() {
		$task = TaskTest::getNewTask();
		$doc1 = Document::create( 'MyDoc', 1, 1, 'text/plain', 'data' );		
		$doc2 = Document::create( 'MyDoc', 1, 1, 'text/plain', 'data' );
		$task->attachDocuments( array($doc1,$doc2) );	
	}

	public function testLoad() {
		$task = TaskTest::getNewTask();
		$task2 = Task::load( $task->id );
		$this->assertEquals( $task, $task2 );
	}

	public function testGetTasksFromQuery() {
		global $db;
		TaskTest::getNewTask(); // creates the task in the db
		TaskTest::getNewTask(); // creates the task in the db
		$sql = " select * from vTasks ";
		$res = $db->query( $sql );
		$tasks = Task::getTasksFromQuery( $res );
		$this->assertTrue( is_array($tasks) );
	}

	public function getTaskFromRow() {
		global $db;
		$task1 = TaskTest::getNewTask(); // creates the task in the db
		$sql = " select * from vTasks where id = '$task1->id' ";
		$res = $db->query( $sql );
		$row = $res->fetch();
		$task2 = Task::getTaskFromRow( $row );
		$this->assertEquals( $task1, $task2 );		
	}
	
	private static function getNewTask() {
		$group = Group::create( 'MyGroup' . rand() );
		$proj = Project::create( 'MyProject' . rand(), $group->id, false );
		return Task::create( 'MyTask', 1, 1, 1, $proj->id, 'my task' );
	}

}

?>