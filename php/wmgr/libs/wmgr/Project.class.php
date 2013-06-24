<?

class Project {

	public $id, $name, $group, $parentID;

	private $ancestors = null, $page = null;

	private static $projects = null;

	/**
	 *  constructor
	 *
	 *  @param [id] the project id
	 *  @param [name] the name of the project
	 *  @param [group] the group the project belongs to
	 *  @param [parentID] (optional) the projects parent
	 *
	 */

	public function __construct( $id, $name, $group, $parentID = false ) {

		$this->id = Data::getInt( $id );
		$this->name = $name;
		$this->group = $group;
		$this->parentID = $parentID;

		// check we were set up ok
		if ( !$this->id ) Error::fatal('bad id for project',Error::SYS);
		if ( !$this->name ) Error::fatal('bad name for project',Error::SYS);
		if ( !$this->group ) Error::fatal('bad group for project',Error::SYS);

	}
	
	/**
	 *  returns the wiki page for this project (if there
	 *  is one, false if there isn't)
	 * 
	 *  @return a wiki page
	 * 
	 */
	
	public function getPage() {
		
		global $db;
		
		if ( $this->page == null ) {

			// first try and see if there has been a page
			// excplicitly set for this project
			$sql = " select p.page_id
				from projects p
				where p.id = '$this->id' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );
			if ( $row = $res->fetch() && $row->page_id )
				$this->page = Page::loadByID( $row->page_id );
			else {

				// otherwise check if there is a name match
				if ( $page = Page::loadByName($this->name,$this->group->id) )
					$this->page = $page;
				else
					$this->page = false;

			}

		}
		
		return $this->page;
	
	}
	
	/**
	 *  sets the page to use for this project
	 * 
	 *  @param [pageID] the pages id
	 * 
	 */
	
	public function setPage( $pageID ) {
		
		global $db;
		
		$sql = " update projects
				set page_id = '$pageID'
				where id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		
		$this->page = null;

	}
	
	/**
	 *  returns an array of this projects ancestors, ordered
	 *  by their distance, furthest first.
	 * 
	 *  @return array of projects
	 * 
	 */
	
	public function getAncestors() {
		
		global $db;
		
		if ( $this->ancestors == null ) {
			
			$this->ancestors = array();
			$sql = " select p.id, p.name, p.parent_id,
						g.id as groupID, g.name as groupName
					from project_hierarchy hp
						right outer join project_hierarchy ha
						on ha.left_node < hp.left_node
							and ha.right_node > hp.right_node
							and ha.tree_id = hp.tree_id
						inner join projects p
						on p.id = ha.project_id
						inner join groups g
						on g.id = p.group_id
					where hp.project_id = '$this->id'
					order by ha.left_node asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() )
				$this->ancestors[] = new Project(
					$row->id, $row->name,
					new Group($row->groupID,$row->groupName),
					$row->parent_id );

		}
		
		return $this->ancestors;
		
	}
	
	/**
	 *  this function refreshes the hierarchy of projects
	 *  that are in the project_hierarchy table
	 * 
	 */
	
	private static function refreshHierarchy() {
		
		global $db;
		
		// fetch all projects
		$projects = Project::fetchAll();
		$treeID = 1;

		$sql = " delete from project_hierarchy ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		foreach ( $projects as $project )
			if ( $project->parentID == false )
				Project::createHierarchyNode( $treeID++, $project, 1 );

	}

	/**
	 *  creates a particular node in the hierarchy, and it's children.  the tree
	 *  id is used because there are multiple hierarchies.
	 * 
	 *  @param [treeID] this nodes tree id
	 *  @param [project] the project for this node
	 *  @param [left] this nodes left value
	 * 
	 *  @return the parent nodes right value
	 *  
	 */

	private static function createHierarchyNode( $treeID, $project, $left ) {

		global $db;

		$right = $left + 1; // assume no children
		$projects = Project::fetchAll();

		// foreach child of this project
		foreach ( $projects as $child )
			if ( $project->id == $child->parentID )
				$right = Project::createHierarchyNode( $treeID, $child, $right );

		$sql = " insert into project_hierarchy ( tree_id, project_id, left_node, right_node ) " .
				" values ( '$treeID', '$project->id', '$left', '$right' ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		return $right + 1;

	}

	/**
	 *  returns an array of the projects in the system
	 * 
	 *  @return an array of projects
	 * 
	 */

	public static function fetchAll() {
		
		global $db, $user;
		
		$userFilter = '';
		if ( $user )
			$userFilter = " where p.group_id in ( " .
							" select gu.group_id " .
							" from group_users gu " .
							" where gu.user_id = '$user->id' ) ";

		if ( self::$projects == null ) {
			self::$projects = array();
			$sql = " select p.id, p.name, p.parent_id, " .
							" g.id as groupID, g.name as groupName " .
						" from projects p " .
							" inner join groups g " .
							" on g.id = p.group_id " .
						$userFilter .
						" order by p.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );
			while ( $row = $res->fetch() )
				array_push( self::$projects,
					new Project( $row->id, $row->name,
						new Group($row->groupID,$row->groupName),
						$row->parent_id )
				);
		}
		
		return self::$projects;
		
	}

	/**
	 *  returns an array of the IMMEDIATE children for the specified
	 *  project id, or if false then will return projects with
	 *  no parent.
	 * 
	 *  @param [parentID] the project parent
	 * 
	 */

	public static function fetchChildren( $parentID, $groupID ) {
		
		global $db, $user;

		$groupFilter = $groupID ? " and p.group_id = '$groupID' " : '';
		$childCondition = $parentID ? " = '$parentID' " : ' is null ';
		$userFilter = '';
		if ( $user )
			$userFilter = " and p.group_id in ( " .
							" select gu.group_id " .
							" from group_users gu " .
							" where gu.user_id = '$user->id' ) ";

		$sql = " select p.id, p.name, count(c.id) as childCount, " .
					" g.id as groupID, g.name as groupName " .
				" from projects p " .
					" left outer join projects c " .
					" on c.parent_id = p.id " .
					" inner join groups g " .
					" on g.id = p.group_id " .
				" where p.parent_id $childCondition " .
				$groupFilter . $userFilter .
				" group by p.id, p.name, g.id, g.name " .
				" order by p.name asc ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$children = array();
		while ( $row = $res->fetch() ) {
			$project = new Project( $row->id, $row->name, new Group($row->groupID,$row->groupName), false );
			$project->childCount = $row->childCount;
			array_push( $children, $project );
		}

		return $children;

	}

	/**
	 *  creates a new project
	 *
	 *  @param [name] the name of the project
	 *  @param [groupID] the group it belongs to
	 *  @param [parentID] the projects parent (false if none)
	 * 
	 *  @return the created project
	 *
	 */

	public static function create( $name, $groupID, $parentID ) {

		global $db;

		$dateFunction = $db->getDateFunction();
		$name = $db->quote( $name );
		$groupID = Data::getInt( $groupID );
		$parentID = Data::getInt($parentID) ? Data::getInt($parentID) : 'null';

		// check parent belongs to same group
		if ( $parentID && $parentID != 'null' ) {
			if ( !$parentProj = Project::load($parentID) )
				Error::fatal( 'invalid parent id' );
			if ( $parentProj->group->id != $groupID )
				Error::fatal( 'parent group does not match project group' );
		}

		$sql = " insert into projects ( name, group_id, date_created, parent_id )
			values ( '$name', '$groupID', $dateFunction, $parentID ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$projectID = $db->getInsertID( 'projects' );

		// make sure nested set hierarchy is up to date
		Project::refreshHierarchy();

		return Project::load( $projectID );

	}

	/**
	 *  loads a project object for the specified project id
	 *
	 *  @param [id] the project id to load
	 * 
	 *  @return the loaded project (false if not found)
	 *
	 */

	public static function load( $id ) {

		global $db, $user;

		// filter on the user if we have one (maybe this is dangerous...?)
		$userFilter = '';
		if ( $user )
			$userFilter = " and p.group_id in ( select distinct gu.group_id
								from group_users gu
								where gu.user_id = '$user->id' ) ";

		$id = Data::getInt( $id );
		$sql = " select p.id, p.name, p.parent_id,
					g.id as groupID, g.name as groupName
			from projects p
				inner join groups g
				on g.id = p.group_id
			where p.id = '$id'
				$userFilter ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$row = $res->fetch();

		return $row ? new Project( $row->id, $row->name,
			new Group( $row->groupID, $row->groupName ),
			$row->parent_id ) : false;

	}

	/**
	 *  returns the total number of projects in the system
	 * 
	 *  @return the number (int) of projects
	 *
	 */

	public static function getTotal() {

		global $db;

		$sql = " select count(p.id) as total
			from projects p ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$row = $res->fetch();

		return $row->total;

	}

}

?>