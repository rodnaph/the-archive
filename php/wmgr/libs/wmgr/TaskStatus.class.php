<?

class TaskStatus {

	public $id, $name, $isClosed, $icon;

	private static $statuses = null, $openStatuses = null;

	/**
	 *  constructor, creates a new TaskStatus object
	 *
	 *  @param [id] the status id
	 *  @param [name] the status name
	 *  @param [isClosed] if this is a closed status type
	 *  @param [icon] (optional) an icon for this status
	 *
	 */

	public function __construct( $id, $name, $isClosed, $icon = false ) {

		$this->id = $id;
		$this->name = $name;
		$this->isClosed = $isClosed;
		$this->icon = $icon;

		if ( !$this->id ) Error::fatal( 'no status id' );
		if ( !$this->name ) Error::fatal( 'no status name' );

	}

	/**
	 *  returns an array of open status types
	 *
	 */

	public static function fetchOpen() {

		if ( self::$openStatuses == null ) {

			$statuses = TaskStatus::fetchAll();
			self::$openStatuses = array();

			foreach ( $statuses as $status )
				if ( !$status->closed )
					array_push( self::$openStatuses, $status );

		}

		return self::$openStatuses;

	}

	/**
	 *  returns an array of all the status types
	 *
	 */

	public static function fetchAll() {

		global $db;

		if ( self::$statuses == null ) {

			self::$statuses = array();
	
			$sql = " select s.id, s.name, s.closed,
						i.id as iconID, i.name as iconName, i.filename as iconFile
				from task_status s
					left outer join icons i
					on i.id = s.icon
				order by s.closed, s.name ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );
	
			while ( $row = $res->fetch() )
				array_push( self::$statuses, new TaskStatus(
					$row->id, $row->name, $row->closed,
					$row->iconID ? new Icon($row->iconID,$row->iconName,$row->iconFile) : false
				));

		}

		return self::$statuses;

	}

}

?>