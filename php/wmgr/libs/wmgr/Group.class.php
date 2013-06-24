<?

/**
 *  groups form the basis for everything on the site, then
 *  are the main containers to which everything else
 *  belongs.
 *
 */

class Group {

	public $id, $name;

	private $users, $tags, $pendingUsers, $latestPages;

	/**
	 *  class constructor
	 *
	 *  @param [id] the group id
	 *  @param [name] the group name
	 *
	 */

	public function __construct( $id, $name ) {

		$this->id = Data::getInt( $id );
		$this->name = $name;

		// check we were set up ok
		if ( !$this->id ) Error::fatal('bad id for group',Error::SYS);
		if ( !$this->name ) Error::fatal('bad name for group',Error::SYS);

		$this->users = null;
		$this->tags = null;
		$this->pendingUsers = null;
		$this->latestPages = null;

	}

	/**
	 *  returns the users in this group (just active users,
	 *  not any pending ones)
	 *
	 */

	public function getUsers() {

		global $db;

		if ( $this->users == null ) {
		
			$sql = " select u.id, u.name, u.email
				from group_users gu
					inner join users u
					on u.id = gu.user_id
				where gu.group_id = '$this->id' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->users = array();

			while ( $row = $res->fetch() )
				array_push( $this->users, new User(
					$row->id, $row->name, $row->email
				));

		}

		return $this->users;

	}

	/**
	 *  returns the tags for this group
	 *
	 */

	public function getTags() {

		global $db;

		if ( $this->tags == null ) {

			$sql = " select gt.id, gt.name
				from group_tags gt
				where gt.group_id = '$this->id'
				order by gt.id asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->tags = array();

			while ( $row = $res->fetch() )
				array_push( $this->tags, new GroupTag(
					$row->id, $row->name
				));

		}

		return $this->tags;

	}

	/**
	 *  updates the groups set of tags.
	 *
	 *  @param [tags] a string array of tags
	 *
	 */

	public function updateTags( $tags ) {

		global $db;

		// remove old tags
		$sql = " delete from group_tags
			where group_id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$this->tags = null;

		// apply new tags (if we have any)
		if ( sizeof($tags) ) {

			$sql = '';

			foreach ( $tags as $tag ) {
				$tag = trim( $tag );
				if ( $tag )
					$sql .= ( $sql ? ',' : '' ) .
					" ( '$this->id', '$tag' ) ";
			}

			$sql = " insert into group_tags ( group_id, name )
				values $sql ";
			if ( !$db->update($sql) )
				Error::fatal( $db->getError(), Error::SYS );

		}

	}

	/**
	 *  adds a user to a group
	 *
	 *  @param [userID] the id of the user to add
	 *
	 */

	public function addUser( $userID ) {

		global $db;

		$dateFunction = $db->getDateFunction();
		$userID = Data::getInt( $userID );
		$sql = " insert into group_users ( group_id, user_id, date_joined )
			values ( '$this->id', '$userID', $dateFunction ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

	}

	/**
	 *  adds a pending user to this group
	 *
	 *  @param [userID] the user id to add
	 *
	 */

	public function addPendingUser( $userID ) {

		global $db;

		$dateFunction = $db->getDateFunction();
		$userID = Data::getInt( $userID );
		$sql = " insert into group_pending ( group_id, user_id, date_requested )
			values ( '$this->id', '$userID', $dateFunction ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

	}

	/**
	 *  removes a user whose pending to be added
	 *
	 *  @param [userID] the user id whose pending
	 *
	 */

	public function removePendingUser( $userID ) {

		global $db;

		$userID = Data::getInt( $userID );
		$sql = " delete from group_pending
			where group_id = '$this->id'
				and user_id = '$userID' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

	}

	/**
	 *  returns an array of users who are pending to be
	 *  join this group.
	 *
	 */

	public function getPendingUsers() {

		global $db;

		if ( $this->pendingUsers == null ) {

			$sql = " select u.id, u.name, u.email
				from group_pending gu
					inner join users u
					on u.id = gu.user_id
				where gu.group_id = '$this->id' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->pendingUsers = array();
			while ( $row = $res->fetch() )
				array_push( $this->pendingUsers, new User(
					$row->id, $row->name, $row->email
				));

		}

		return $this->pendingUsers;

	}

	/**
	 *  returns the number of pending users for this group
	 *
	 */

	public function getPendingUsersCount() {

		return sizeof( $this->getPendingUsers() );

	}

	/**
	 *  determines if a user is a member of this group
	 *
	 *  @param [checkUser] the user to check
	 *
	 */

	public function isMember( $checkUser ) {

		$users = $this->getUsers();

		foreach ( $users as $u )
			if ( $checkUser->id == $u->id )
				return true;

		return false;

	}

	/**
	 *  indicates if a user is pending to become
	 *  a member of this group.
	 *
	 *  @param [checkUser] the user to check
	 *
	 */

	public function isPending( $checkUser ) {

		$pending = $this->getPendingUsers();

		foreach ( $pending as $u )
			if ( $checkUser->id == $u->id )
				return true;

		return false;

	}

	/**
	 *  returns the latest pages that have been created
	 *  for this group.
	 *
	 */

	public function getLatestPages() {

		global $db;

		if ( $this->latestPages == null ) {

			$preLimit = $db->getPreLimit( 10 );
			$postLimit = $db->getPostLimit( 10 );
			$dateEdited = $db->getUnixTimeStamp( 'p.date_edited' );
			$sql = " select $preLimit p.id, p.name, p.body, $dateEdited as dateEdited, p.parent_id,
					u.id as u_id, u.name as u_name, u.email as u_email,
					g.id as g_id, g.name as g_name
				from pages p
					inner join users u
					on u.id = p.user_id
					inner join groups g
					on g.id = p.group_id
				where p.group_id = '$this->id'
				order by p.date_created desc
				$postLimit ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->latestPages = array();
			while ( $row = $res->fetch() )
				array_push( $this->latestPages, new Page(
					$row->id, $row->name, $row->body,
					new User($row->u_id,$row->u_name,$row->u_email),
					new Group($row->g_id,$row->g_name),
					$row->dateEdited, $row->parent_id
				));

		}

		return $this->latestPages;

	}

	/**
	 *  returns the projects for this group
	 *
	 */

	public function getProjects() {

		global $db;

		if ( $this->projects == null ) {

			$sql = " select p.id, p.name, p.parent_id,
						g.id as groupID, g.name as groupName
				from projects p
					inner join groups g
					on g.id = p.group_id
				where p.group_id = '$this->id'
				order by p.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->projects = array();
			while ( $row = $res->fetch() )
				array_push( $this->projects, new Project(
					$row->id, $row->name,
					new Group($row->groupID,$row->groupName),
					$row->parent_id
				));

		}

		return $this->projects;

	}

	/**
	 *  creates a new group
	 *
	 *  @param [name] the name of the group
	 *
	 */

	public static function create( $name ) {

		global $db, $user;

		// create the group
		$name = $db->quote( $name );
		$dateFunction = $db->getDateFunction();
		$sql = " insert into groups ( name, date_created )
			values ( '$name', $dateFunction ) ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$id = $db->getInsertID( 'groups' );

		// then give user who created it full control
		$group = new Group( $id, $name );
		$group->addUser( $user->id );

		return $group;

	}

	/**
	 *  loads a group for a specified id
	 *
	 *  @param [groupID] the id of the group to load
	 *
	 */

	public static function load( $groupID ) {

		global $db;

		$groupID = Data::getInt( $groupID );
		$sql = " select id, name
			from groups
			where id = '$groupID' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$row = $res->fetch();

		return $row ? new Group($row->id,$row->name) : false;

	}

	/**
	 *  fetches an array of Group objects for the latest
	 *  groups that have been created.
	 *
	 */

	public static function getLatest() {

		global $db;

		$preLimit = $db->getPreLimit( 5 );
		$postLimit = $db->getPostLimit( 5 );
		$sql = " select $preLimit g.id, g.name, count(gu.group_id) as users
			from groups g
				left outer join group_users gu
				on gu.group_id = g.id
			group by g.id, g.name, g.date_created
			order by g.date_created desc
			$postLimit ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$latest = array();
		
		while ( $row = $res->fetch() )
			array_push( $latest, new Group(
				$row->id, $row->name
			));

		return $latest;

	}

	/**
	 *  returns the total number of groups in the system
	 *
	 */

	public static function getTotal() {

		global $db;

		$sql = " select count(g.id) as total
			from groups g ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$row = $res->fetch();

		return $row->total;

	}

}

?>