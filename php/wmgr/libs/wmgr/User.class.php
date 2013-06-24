<?

/**
 *  this class represents a user of the system
 *
 */

class User {

	public $id, $name, $email;

	private $groups, $projects, $tasks, $latestTasks, $pages;

	/**
	 *  class constructor
	 *
	 *  @param [id] the user id
	 *  @param [name] the user name
	 *  @param [email] the users email
	 *
	 */

	function __construct( $id, $name, $email ) {

		$this->id = Data::getInt( $id );
		$this->name = $name;
		$this->email = $email;

		if ( !$this->id ) Error::fatal('bad id for user',Error::SYS);
		if ( !$this->name ) Error::fatal('bad name for user',Error::SYS);
		if ( !$this->email ) Error::fatal('bad email for user',Error::SYS);

		$this->groups = null;
		$this->projects = null;
		$this->tasks = null;
		$this->latestTasks = null;
		$this->pages = null;

	}

	/**
	 *  logs a users out and ends their session
	 *
	 */

	public function logout() {

		if ( session_id() )
			session_destroy();

	}

	/**
	 *  updates the users session with the latest user
	 *  information from this object
	 *
	 */

	public function updateSession() {

		if ( session_id() )
			session_destroy();

		session_start();

		$_SESSION['user_id'] = $this->id;

	}

	/**
	 *  returns an array of the users groups
	 *
	 */

	public function getGroups() {

		global $db;

		if ( $this->groups == null ) {

			$sql = " select g.id, g.name
				from group_users gu
					inner join groups g
					on g.id = gu.group_id
				where gu.user_id = '$this->id'
				order by g.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->groups = array();
			while ( $row = $res->fetch() )
				array_push( $this->groups, new Group(
					$row->id, $row->name
				));

		}

		return $this->groups;

	}

	/**
	 *  returns an array of tasks for this user
	 *
	 */

	public function getTasks() {

		global $db;

		if ( $this->tasks == null ) {

			$sql = " select t.*
				from task_users tu
					inner join vTasks t
					on t.id = tu.task_id
					inner join task_status s
					on s.id = t.statusID
				where tu.user_id = '$this->id'
					and s.closed = 0 ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->tasks = Task::getTasksFromQuery($res);

		}

		return $this->tasks;

	}

	/**
	 *  returns an array of the projects this user has access to
	 *
	 */

	public function getProjects() {

		global $db;

		if ( $this->projects == null ) {

			$sql = " select p.id, p.name,
						g.id as groupID, g.name as groupName
				from group_users gu
					right outer join projects p
					on p.group_id = gu.group_id
					inner join groups g
					on g.id = p.group_id
				where gu.user_id = '$this->id'
				order by p.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->projects = array();
			while ( $row = $res->fetch() )
				array_push( $this->projects, new Project(
					$row->id, $row->name,
					new Group($row->groupID,$row->groupName)
				));

		}

		return $this->projects;

	}

	/**
	 *  returns the 10 latest tasks for this user
	 *
	 */

	public function getLatestTasks() {

		global $db;

		if ( $this->latestTasks == null ) {

			$preLimit = $db->getPreLimit( 10 );
			$postLimit = $db->getPostLimit( 10 );
			$sql = " select $preLimit t.*
				from vTasks t
					inner join task_status ts
					on ts.id = t.statusID
				where t.id in (
						select tu.task_id
						from task_users tu
						where tu.user_id = '$this->id'
						group by tu.task_id 
					)
					and ts.closed = 0
				order by t.dateCreated desc
				$postLimit ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->latestTasks = Task::getTasksFromQuery($res);

		}

		return $this->latestTasks;

	}

	/**
	 *  returns all the pages this user has access to
	 * 
	 *  @return array of pages
	 * 
	 */

	public function getPages() {
		
		global $db;
		
		if ( $this->pages == null ) {
			
			$this->pages = array();
			$dateEdited = $db->getUnixTimeStamp( 'p.date_edited' );
			$sql = " select p.id, p.name, p.body, $dateEdited as dateEdited, p.parent_id,
						u.id as userID, u.name as userName, u.email as userEmail,
						g.id as groupID, g.name as groupName
					from pages p
						inner join users u
						on u.id = p.user_id
						inner join groups g
						on g.id = p.group_id
					where p.group_id in (
						select gu.group_id
						from group_users gu
						where gu.user_id = '$this->id' ) ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() )
				$this->pages[] = new Page(
					$row->id, $row->name, $row->body,
					new User($row->userID,$row->userName,$row->userEmail),
					new Group($row->groupID,$row->groupName),
					$row->dateEdited, $row->parent_id );

		}

		return $this->pages;
		
	}

	/**
	 *  this function tried to register a new user.  that user
	 *  is then returned.
	 *
	 *  @param [name] the users name
	 *  @param [pass] the users plaintext password
	 *  @param [email] the users email
	 *
	 */

	public static function register( $name, $pass, $email ) {

		global $db;

		$hash = md5( $pass );
		$name = $db->quote( $name );
		$email = $db->quote( $email );
		$dateFunction = $db->getDateFunction();
		$sql = " insert into users ( name, pass, email, date_created )
			values ( '$name', '$hash', '$email', $dateFunction ) ";

		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$id = $db->getInsertID( 'users' );

		return User::load( $id );

	}

	/**
	 *  loads a user from the database for the specified ID
	 *
	 *  @param [id] the user id to load
	 *
	 */

	public static function load( $id ) {

		global $db;

		$id = Data::getInt( $id );
		$sql = " select id, name, email
			from users
			where id = '$id' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		if ( !$row = $res->fetch() )
			Error::fatal( "unable to find expected user id '$id'", Error::SYS );

		return new User(
			$row->id, $row->name, $row->email
		);

	}

	/**
	 *  tries to authenticate a user, and start a session for
	 *  them with the site.
	 *
	 *  @param [name] the users name
	 *  @param [pass] the users plaintext password
	 *
	 */

	public static function login( $name, $pass ) {

		global $db;

		// try and fetch user
		$name = $db->quote( $name );
		$sql = " select id, pass
			from users
			where name = '$name' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		if ( !$row = $res->fetch() )
			return false;

		// check password
		if ( $row->pass != md5($pass) )
			return false;

		// if we get here we should be all good
		$user = User::load( $row->id );
		$user->updateSession();

		return $user;

	}

	/**
	 *  tries to restore a user object from a session
	 *
	 */

	public static function restoreSession() {

		session_start();

		$userID = $_SESSION['user_id'];

		return $userID ? User::load($userID) : false;

	}

	/**
	 *  returns the total number of users in the system
	 *
	 */

	public static function getTotal() {

		global $db;

		$sql = " select count(u.id) as total
			from users u ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$row = $res->fetch();

		return $row->total;

	}

}

?>