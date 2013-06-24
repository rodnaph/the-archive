<?

class Page {

	var $id, $name, $body, $user, $group, $dateEdited, $parentID, $childCount;

	private $history;

	/**
	 *  class constructor
	 *
	 *  @param [id] the page id
	 *  @param [name] the page name
	 *  @param [body] the (unformatted) page body
	 *  @param [user] the last user to edit the page
	 *  @param [dateEdited] the date the page was edited (unix)
	 *  @param [parentID] the pages parent
	 */

	public function __construct( $id, $name, $body, $user, $group, $dateEdited, $parentID ) {

		$this->id = Data::getInt( $id );
		$this->name = $name;
		$this->body = $body;
		$this->user = $user;
		$this->group = $group;
		$this->dateEdited = Data::getInt( $dateEdited );
		$this->parentID = $parentID;

		// check we were set up ok
		if ( !$this->id ) Error::fatal('bad id for page',Error::SYS);
		if ( !$this->name ) Error::fatal('bad name for page',Error::SYS);
		if ( !$this->user ) Error::fatal('bad user for page',Error::SYS);
		if ( !$this->group ) Error::fatal('bad group for page',Error::SYS);
		if ( !$this->dateEdited ) Error::fatal('bad date for page',Error::SYS);

		$this->history = null;
		$this->childCount = null;

	}
	
	/**
	 *  returns an array of this pages ancestors, ordered by
	 *  their distance (furthest first)
	 * 
	 *  @param array of pages
	 * 
	 */
	
	public function getAncestors() {

		global $db;
		
		$dateEdited = $db->getUnixTimeStamp( 'p.date_edited' );
		$sql = " select p.id, p.name, p.body, $dateEdited as dateEdited, p.parent_id,
					u.id as userID, u.name as userName, u.email as userEmail,
					g.id as groupID, g.name as groupName
				from page_hierarchy h
					right outer join page_hierarchy a
					on a.left_node < h.left_node
						and a.right_node > h.right_node
						and a.tree_id = h.tree_id
					inner join pages p
					on p.id = a.page_id
					inner join users u
					on u.id = p.user_id
					inner join groups g
					on g.id = p.group_id
				where h.page_id = '$this->id'
				order by a.left_node asc ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$ancestors = array();
		while ( $row = $res->fetch() )
			$ancestors[] = new Page(
				$row->id, $row->name, $row->body,
				new User( $row->userID, $row->userName, $row->userEmail ),
				new Group( $row->groupID, $row->groupName ),
				$row->dateEdited, $row->parent_id
			);

		return $ancestors;

	}

	/**
	 *  returns the name of this pages parent if it
	 *  has one, the empty string otherwise
	 * 
	 *  @return string name
	 * 
	 */
	
	public function getParentName() {

		global $db;

		if ( $this->parentID ) {
			$sql = " select p.name
					from pages p
					where p.id = '$this->parentID' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );
			if ( $row = $res->fetch() )
				return $row->name;
		}
		
		// otherwise nope
		return '';

	}

	/**
	 *  returns the text body of this page
	 *
	 */

	public function getBody() {
		return $this->body;
	}

	/**
	 *  returns the name of the page
	 *
	 */

	public function getName() {
		return $this->name;
	}

	/**
	 *  creates a new page
	 *
	 *  @param [name] the name of the page to create
	 *  @param [body] the page body texts
	 *  @param [groupID] the group the page belongs to
	 *  @param [parentID] (optional) page parent
	 *
	 */

	public static function create( $name, $body, $groupID, $parentID = false ) {

		global $db, $user;

		// create the page
		$parentID = Data::getInt($parentID) ? Data::getInt($parentID) : 'null';
		$dateFunction = $db->getDateFunction();
		$name = $db->quote( $name );
		$body = $db->quote( $body );
		$groupID = Data::getInt( $groupID );
		$sql = " insert into pages ( name, body, date_edited, group_id, user_id, date_created, parent_id )
			values ( '$name', '$body', $dateFunction, '$groupID', '$user->id', $dateFunction, $parentID ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// load the page to return
		$pageID = $db->getInsertID( 'pages' );
		$page = Page::loadByID( $pageID, $groupID );

		$page->refreshHierarchy();

		return $page;

	}

	/**
	 *  updates a page with a new body and the groups
	 *  the page belongs to
	 *
	 *  @param [body] the new page body
	 *
	 */

	public function update( $body, $parentID ) {

		global $db, $user;

		// archive current copy
		$sql = " insert into page_history ( page_id, user_id, body, date_edited )
			select '$this->id', user_id, body, date_edited
			from pages
			where id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// then update it
		$parent = Data::getInt($parentID) ? Data::getInt($parentID) : 'null';
		$dateFunction = $db->getDateFunction();
		$body = $db->quote( $body );
		$sql = " update pages
			set body = '$body',
				user_id = '$user->id',
				parent_id = $parent,
				date_edited = $dateFunction
			where id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$refreshHierarchy = false;
		if ( $this->parentID != $parentID )
			$refreshHierarchy = true;

		$this->body = $body;
		$this->parentID = $parentID;

		if ( $refreshHierarchy )
			$this->refreshHierarchy();

	}

	/**
	 *  returns the history for this page
	 * 
	 *  @return array of PageHistory objects
	 *
	 */

	public function getHistory() {

		global $db;

		if ( $this->history == null ) {

			$dateEdited = $db->getUnixTimeStamp( 'h.date_edited' );
			$sql = " select h.id, h.body, $dateEdited as date_edited,
					u.id as u_id, u.name as u_name, u.email as u_email
				from page_history h
					inner join users u
					on u.id = h.user_id
				where h.page_id = '$this->id'
				order by h.date_edited desc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			$this->history = array();
			while ( $row = $res->fetch() )
				array_push( $this->history, new PageHistory(
					$row->id, $row->body,
					new User($row->u_id,$row->u_name,$row->u_email),
					$row->date_edited
				));

		}

		return $this->history;

	}

	/**
	 *  this function refreshes the hierarchy of pages
	 *  that are in the page_hierarchy table.  it tries to
	 *  do this efficiently by only refreshing the parts of
	 *  the hierarchy that have changed.
	 * 
	 */
	
	private function refreshHierarchy() {
		
		global $db;

		// fetch tree id's that need updating
		$treeSQL = '';
		$parentSQL = '';
		if ( $this->parentID )
			$parentSQL = " , '$this->parentID' ";
		$sql = " select distinct h.tree_id
				from page_hierarchy h
				where h.page_id in ( '$this->id' $parentSQL ) ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		while ( $row = $res->fetch() )
			$treeSQL .= " , '$row->tree_id' ";

		// delete the trees that need refreshing
		$sql = " delete from page_hierarchy
				where tree_id in ( -1 $treeSQL ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// fetch all pages not in the hierarchy
		$pages = array();
		$sql = " select p.id, p.parent_id
				from pages p
				where p.id not in (
					select page_id
					from page_hierarchy
				) ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		while ( $row = $res->fetch() )
			$pages[] = $row;

		// fetch a new tree id to use
		$sql = " select max(h.tree_id) as maxTreeID
				from page_hierarchy h ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->query($sql), Error::SYS );
		$row = $res->fetch();
		$treeID = $row->maxTreeID + 1;

		// find root nodes to build tree from
		foreach ( $pages as $page )
			if ( !$page->parent_id )
				Page::createHierarchyNode( $pages, $page, $treeID++, 1 );

	}

	/**
	 *  delete this page from the system
	 * 
	 */

	public function delete() {
		
		global $db;

		// remove this page from any projects
		// it's attached to.
		$sql = " update projects
				set page_id = '$this->parentID'
				where page_id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// remove from hierarchy (just attaches any children to
		// this nodes parent, a refresh of the hierarchy will still
		// be needed)
		$sql = " update pages
				set parent_id = '$this->parentID'
				where parent_id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// page history
		$sql = " delete from page_history
				where page_id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		
		// page
		$sql = " delete from pages
				where id = '$this->id' ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		// refresh hierarchy
		$this->refreshHierarchy();
		
	}

	/**
	 *  creates a particular node in the hierarchy, and it's children.  the tree
	 *  id is used because there are multiple hierarchies.
	 * 
	 *  @param [treeID] this nodes tree id
	 *  @param [page] the page for this node
	 *  @param [left] this nodes left value
	 * 
	 *  @return the parent nodes right value
	 *  
	 */

	private static function createHierarchyNode( $pages, $page, $treeID, $left ) {

		global $db;

		$right = $left + 1; // assume no children

		// look for children
		foreach ( $pages as $child )
			if ( $page->id == $child->parent_id )
				$right = Page::createHierarchyNode( $pages, $child, $treeID, $right );

		$sql = " insert into page_hierarchy ( tree_id, page_id, left_node, right_node ) " .
				" values ( '$treeID', '$page->id', '$left', '$right' ) ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		return $right + 1;

	}

	/**
	 *  loads a page by it's id
	 *
	 *  @param [id] the id of the page to load
	 *
	 */

	public static function loadByID( $id ) {
		return Page::load( $id, false, false );
	}

	/**
	 *  loads a page by it's name.  page names are not unique
	 *  across groups so if you're loading by name you also
	 *  need to specify the group to load the page for.
	 *
	 *  @param [name] the name of the page to load
	 *  @param [groupID] the pages group
	 *
	 */

	public static function loadByName( $name, $groupID ) {
		return Page::load( false, $name, $groupID );
	}

	/**
	 *  this function loads a page by either it's id or
	 *  it's name.  only ONE of these arguments should be
	 *  specified.  and you only need to specify the group
	 *  if you're loading by name.
	 *
	 *  @param [id] the id of the page to load
	 *  @param [name] the name of the page to load
	 *  @param [groupID] the group the page belongs to
	 *
	 */

	private static function load( $id, $name, $groupID ) {

		global $db, $user;

		// check the args are ok
		if ( $id && $name )
			Error::fatal( 'you must only specify one argument', Error::SYS );

		// filter on user?
		$userSQL = '';
		if ( $user )
			$userSQL = " and p.group_id in (
							select gu.group_id
							from group_users gu
							where user_id = '$user->id'
						) ";

		$id = Data::getInt( $id );
		$name = $db->quote( $name );
		$groupID = Data::getInt( $groupID );
		$dateEdited = $db->getUnixTimeStamp( 'p.date_edited' );
		$sql = " select p.id, p.name, p.body, $dateEdited as date_edited, p.parent_id,
				u.id as user_id, u.name as user_name, u.email as user_email,
				g.id as g_id, g.name as g_name
			from pages p
				inner join users u
				on u.id = p.user_id
				inner join groups g
				on g.id = p.group_id
			where " . ( $id ? " p.id = '$id' " : " p.name = '$name' and p.group_id = '$groupID' " ) . "
				$userSQL ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$row = $res->fetch();

		return $row ? new Page(
			$row->id, $row->name, $row->body,
			new User( $row->user_id, $row->user_name, $row->user_email ),
			new Group( $row->g_id, $row->g_name ),
			$row->date_edited, $row->parent_id
		) : false;

	}

	/**
	 *  returns the total number of pages in the system
	 *
	 */

	public static function getTotal() {

		global $db;

		$sql = " select count(p.id) as total
			from pages p ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		$row = $res->fetch();

		return $row->total;

	}

	/**
	 *  returns an array of children for the specifed page
	 * 
	 *  @param [parentID] parent to fetch children for (false for null parents)
	 *  @param [groupID] group to filter on
	 * 
	 */

	public static function fetchChildren( $parentID, $groupID ) {

		global $db, $user;

		// parent filter
		$parentSQL = $parentID ? " = '$parentID' " : ' is null ';
		
		// group filter
		$groupSQL = '';
		if ( $groupID )
			$groupSQL = " and p.group_id = '$groupID' ";

		// user filter
		$userSQL = '';
		if ( $user )
			$userSQL = '';

		$dateEdited = $db->getUnixTimeStamp( 'p.date_edited' );
		$sql = " select p.id, p.name, p.body, $dateEdited as date_edited, p.parent_id,
					u.id as userID, u.name as userName, u.email as userEmail,
					g.id as groupID, g.name as groupName,
					count(c.id) as childCount
				from pages p
					inner join users u
					on u.id = p.user_id
					inner join groups g
					on g.id = p.group_id
					left outer join pages c
					on c.parent_id = p.id
				where p.parent_id $parentSQL
					$groupSQL
					$userSQL
				group by p.id, p.name, p.date_edited, p.parent_id,
					u.id, u.name, u.email,
					g.id, g.name
				order by p.name asc ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(),Error::SYS );

		$children = array();
		while ( $row = $res->fetch() ) {
			$page = new Page(
				$row->id, $row->name, $row->body,
				new User($row->userID,$row->userName,$row->userEmail),
				new Group($row->groupID,$row->groupName),
				$row->date_edited, $row->parent_id
			);
			$page->childCount = $row->childCount;
			$children[] = $page;
		}

		return $children;

	}

}

?>