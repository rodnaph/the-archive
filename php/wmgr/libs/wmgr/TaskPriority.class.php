<?

class TaskPriority {

	public $id, $name, $icon;

	private static $priorities = null; 

	/**
	 *  constructor
	 *
	 *  @param [id] the priority id
	 *  @param [name] the priority name
	 *  @param [icon] (optional) an icon for this priority
	 *
	 */

	public function __construct( $id, $name, $icon = false ) {

		$this->id = $id;
		$this->name = $name;
		$this->icon = $icon;

		if ( !$this->id ) Error::fatal( 'no priority id' );
		if ( !$this->name ) Error::fatal( 'no priority name' );

	}

	/**
	 *  returns an array of all the task priorities
	 *
	 */

	public static function fetchAll() {

		global $db;

		if ( self::$priorities == null ) {

			self::$priorities = array();

			$sql = " select p.id, p.name,
						i.id as iconID, i.name as iconName, i.filename as iconFile
				from task_priorities p
					left outer join icons i
					on i.id = p.icon
				order by p.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() )
				array_push( self::$priorities, new TaskPriority(
					$row->id, $row->name,
					$row->iconID ? new Icon($row->iconID,$row->iconName,$row->iconFile) : false
				));

		}

		return self::$priorities;

	}

}