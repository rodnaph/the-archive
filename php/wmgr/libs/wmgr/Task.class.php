<?

class Task {

	public $id, $name, $status, $priority, $type,
		$description, $dateCreated, $creator,
		$historyID, $project;

	private $history, $docs;

	/**
	 *  constructor
	 *
	 *  @param [id] the task id
	 *  @param [name] the task name
	 *  @param [creator] the user who created the task
	 *  @param [status] the task status
	 *  @param [type] the task type
	 *  @param [priority] the task priority
	 *  @param [description] description of the task
	 *  @param [dateCreated] the date the task was created
	 *  @param [historyID] the latest history id
	 *  @param [project] the tasks project
	 *
	 */

	public function __construct( $id, $name, $creator, $status, $type, $priority, $description, $dateCreated, $historyID, $project ) {

		$this->id = $id;
		$this->name = $name;
		$this->creator = $creator;
		$this->status = $status;
		$this->type = $type;
		$this->priority = $priority;
		$this->description = $description;
		$this->dateCreated = $dateCreated;
		$this->historyID = $historyID;
		$this->project = $project;

		if ( !$this->id ) Error::fatal( 'no task id' );
		if ( !$this->name ) Error::fatal( 'no task name' );
		if ( !$this->creator ) Error::fatal( 'no task creator' );
		if ( !$this->status ) Error::fatal( 'no task status' );
		if ( !$this->type ) Error::fatal( 'no task type' );
		if ( !$this->priority ) Error::fatal( 'no task priority' );
		if ( !$this->description ) Error::fatal( 'no task description' );
		if ( !$this->dateCreated ) Error::fatal( 'no task date created' );
		if ( !$this->historyID ) Error::fatal( 'no task history id' );

		$this->history = null;
		$this->docs = array();

	}

	/**
	 *  adds a user to a task
	 *
	 *  @param [userID] the user to add to the task
	 *
	 */

	public function addUser( $userID ) {

		global $db;

		$sql = " insert into task_users ( task_id, user_id )
			values ( '$this->id', '$userID' ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

	}

	/**
	 *  adds history to a task
	 *
	 *  TODO
	 *  there is currently overlap between this function and the static
	 *  create() function.
	 *
	 *  @param [name] task name
	 *  @param [status] task status id
	 *  @param [type] task type id
	 *  @param [priority] task priority id
	 *  @param [description] user comments
	 *  @param [project] the tasks project
	 *
	 */

	public function update( $name, $status, $type, $priority, $description, $project ) {

		global $db, $user;

		$description = $db->quote( $description );

		// then add the task history data
		$dateFunction = $db->getDateFunction();
		$sql = " insert into task_history ( task_id, user_id, status_id,
				type_id, priority_id, description, name,
				date_actioned, project_id )
			values ( '$this->id', '$user->id', '$status',
				'$type', '$priority', '$description', '$name',
				$dateFunction, '$project' ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

	}

	/**
	 *  returns a complete history for a task in the form
	 *  of an array of task objects for each point in this
	 *  tasks history.
	 *
	 */

	public function getHistory() {

		global $db;

		if ( $this->history == null ) {

			$this->history = array();
			$dateActioned = $db->getUnixTimeStamp( 'h.date_actioned' );
			$sql = " select t.id,
					h.id as historyID, h.name, $dateActioned as dateCreated, h.description,
					s.id as statusID, s.name as statusName, s.closed as statusClosed,
					si.id as statusIconID, si.name as statusIconName, si.filename as statusIconFile,
					tt.id as typeID, tt.name as typeName,
					tti.id as typeIconID, tti.name as typeIconName, tti.filename as typeIconFile,
					p.id as priorityID, p.name as priorityName,
					pi.id as priorityIconID, pi.name as priorityIconName, pi.filename as priorityIconFile,
					u.id as creatorID, u.name as creatorName, u.email as creatorEmail,
					pr.id as projectID, pr.name as projectName, pr.parent_id as projectParentID,
					gr.id as projectGroupID, gr.name as projectGroupName
				from tasks t
					right outer join task_history h
					on h.task_id = t.id
					inner join task_status s
					on s.id = h.status_id
					inner join task_priorities p
					on p.id = h.priority_id
					inner join task_types tt
					on tt.id = h.type_id
					inner join users u
					on u.id = h.user_id
					left outer join icons tti
					on tti.id = tt.icon
					left outer join icons si
					on si.id = s.icon
					left outer join icons pi
					on pi.id = p.icon
					inner join projects pr
					on pr.id = h.project_id
					inner join groups gr
					on gr.id = pr.group_id
				where t.id = '$this->id'
				order by h.date_actioned asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() ) {
				$task = Task::getTaskFromRow($row);
				array_unshift( $this->history, $task );
				if ( sizeof($this->history) > 0 )
					$task->previous = $this->history[1];
			}

			// now we have ths histories, we can
			// query for any attached documents
			// and then add them to the histories
			$dateCreated = $db->getUnixTimeStamp( 'd.date_created' );
			$sql = " select h.id as historyID,
					d.id as id, d.name, $dateCreated as dateCreated, d.bin_size, d.bin_type,
					u.id as userID, u.name as userName, u.email as userEmail
				from task_history h
					left outer join task_docs td						
					on td.task_history_id = h.id
					inner join docs d
					on d.id = td.doc_id
					inner join users u
					on u.id = d.user_id
				where h.task_id = '$this->id' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() )
				foreach ( $this->history as $history )
					if ( $history->historyID == $row->historyID )
						$history->addDocument( new Document(
							$row->id, $row->name,
							new User($row->userID,$row->userName,$row->userEmail),
							$row->dateCreated, $row->bin_size, $row->bin_type
						));

		}

		return $this->history;

	}

	/**
	 *  adds a document to this task (MEMORY ONLY! THIS
	 *  DOES NOT EFFECT THE DATABASE!)
	 *
	 *  @param [doc] the document to add
	 *
	 */

	public function addDocument( $doc ) {

		array_push( $this->docs, $doc );

	}

	/**
	 *  returns the documenys that have been added to this
	 *  task with the addDocument() function.
	 *
	 */

	public function getDocuments() {

		return $this->docs;

	}

	/**
	 *  attaches some documents to a task, this stores these
	 *  document id's against this task in the database
	 *
	 *  @param [docs] array of document id's
	 *
	 */

	public function attachDocuments( $docs ) {

		global $db, $user;

		// fetch history id to attach to
		$sql = " select max(id) as historyID
			from task_history
			where task_id = '$this->id' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$row = $res->fetch();
		$historyID = $row->historyID;

		// create the sql
		$sql = '';
		foreach ( $docs as $docID )
			$sql .= ( $sql ? ' , ' : '' ) .
				" ( '$historyID', '$docID' ) ";

		// do the insert
		if ( $sql ) {
			$sql = " insert into task_docs ( task_history_id, doc_id )
				values $sql; ";
			if ( !$db->update($sql) )
				Error::fatal( $db->getError(), Error::SYS );
		}

	}

	/**
	 *  creates a new task
	 * 
	 *  @param [name] the name of the task
	 *  @param [status] the status
	 *  @param [type] the task type
	 *  @param [priority] the task priority
	 *  @param [project] the task project
	 *  @param [description] the description of the task
	 *
	 */

	public static function create( $name, $status, $type, $priority, $project, $description ) {

		global $db, $user;

		// create the task
		$sql = " insert into tasks values () ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$taskID = $db->getInsertID( 'tasks' );

		// then add the task history data
		$dateFunction = $db->getDateFunction();
		$name = $db->quote( $name );
		$description = $db->quote( $description );
		$sql = " insert into task_history ( task_id, user_id, status_id,
				type_id, priority_id, description, name,
				date_actioned, project_id )
			values ( '$taskID', '$user->id', '$status',
				'$type', '$priority', '$description', '$name',
				$dateFunction, '$project' ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$task = Task::load( $taskID );
		$task->addUser( $user->id );

		return $task;

	}

	/**
	 *  loads a task for a specific id
	 *
	 *  @param [id] the task id to load
	 *
	 */

	public static function load( $id ) {

		global $db, $user;

		$sql = " select t.*
			from vTasks t
			where t.id = '$id' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		if ( $row = $res->fetch() )
			return Task::getTaskFromRow($row);

		// task not found
		else return false;

	}

	/**
	 *  takes the result of a database query and tries to turn
	 *  it into an array of task objects.
	 *
	 *  NB!  this assumes the result columns are named the same
	 *  as the vTasks view!
	 *
	 *  @param [res] the database query result
	 *
	 */

	public static function getTasksFromQuery( $res ) {

		$tasks = array();

		while ( $row = $res->fetch() )
			array_push( $tasks, Task::getTaskFromRow($row) );

		return $tasks;

	}

	/**
	 *  takes a row from a result set and tries to turn
	 *  it into an array of task objects.
	 *
	 *  NB!  this assumes the result columns are named the same
	 *  as the vTasks view!
	 *
	 *  @param [row] the row to use
	 *
	 */

	public static function getTaskFromRow( $row ) {

		return new Task(
			$row->id, $row->name,
			new User($row->creatorID,$row->creatorName,$row->creatorEmail),
			new TaskStatus(
				$row->statusID,$row->statusName,$row->statusClosed,
				$row->statusIconID ? new Icon($row->statusIconID,$row->statusIconName,$row->statusIconFile) : false
			),
			new TaskType(
				$row->typeID,$row->typeName,
				$row->typeIconID ? new Icon($row->typeIconID,$row->typeIconName,$row->typeIconFile) : false
			),
			new TaskPriority(
				$row->priorityID,$row->priorityName,
				$row->priorityIconID ? new Icon($row->priorityIconID,$row->priorityIconName,$row->priorityIconFile) : false
			),
			$row->description, $row->dateCreated, $row->historyID,
			new Project(
				$row->projectID, $row->projectName,
				new Group($row->projectGroupID,$row->projectGroupName),
				$row->projectParentID
			)
		);

	}

}

?>