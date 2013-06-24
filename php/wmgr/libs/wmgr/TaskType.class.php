<?

class TaskType {

	public $id, $name, $icon;

	private static $types = null; 

	/**
	 *  constructor
	 *
	 *  @param [id] the type id
	 *  @param [name] the type name
	 *  @param [icon] (optional) icon
	 *
	 */

	public function __construct( $id, $name, $icon = false ) {

		$this->id = $id;
		$this->name = $name;
		$this->icon = $icon;

		if ( !$this->id ) Error::fatal( 'no type id' );
		if ( !$this->name ) Error::fatal( 'no type name' );


	}

	/**
	 *  returns an array of all the task types
	 *
	 */

	public static function fetchAll() {

		global $db;

		if ( self::$types == null ) {

			self::$types = array();

			$sql = " select t.id, t.name,
						i.id as iconID, i.name as iconName, i.filename as iconFile
				from task_types t
					left outer join icons i
					on i.id = t.icon
				order by t.name asc ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );

			while ( $row = $res->fetch() )
				array_push( self::$types, new TaskType(
					$row->id, $row->name,
					$row->iconID ? new Icon($row->iconID,$row->iconName,$row->iconFile) : false
				));

		}

		return self::$types;

	}

}