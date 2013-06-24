<?

/**
 *  a class for connecting to, and interacting with MySQL
 *  databases.
 *
 */

class Database extends Database_WMgr {

	var $cnn = false;
	private $host;

	/**
	 *  tries to connect to the database
	 *
	 *  @param [host] the hostname of the db server
	 *  @param [name] the name of the database
	 *  @param [user] the username to connect as
	 *  @param [pass] the password to use
	 *
	 */

	function connect( $host, $user, $pass, $name = false ) {

		$this->host = $host;

		$this->cnn = mysql_connect( $host, $user, $pass );

		if ( $this->cnn && $name )
			$this->select( $name );

		return ( $this->cnn );

	}
	
	public function disconnect() {
		
		mysql_close( $this->cnn );
		$this->cnn = null;

	}

	public function select( $name ) {

		mysql_select_db( $name, $this->cnn );

	}

	/**
	 *  queries the database with the specified sql
	 *
	 *  @param [sql] the sql for the query
	 *
	 */

	function query( $sql ) {

		$res = mysql_query( $sql, $this->cnn );

		return $res ? new DatabaseQuery($res) : false;

	}

	/**
	 *  performs an update on the database using the
	 *  specified sql
	 *
	 *  @param [sql] the sql for the update
	 *
	 */

	function update( $sql ) {
		return ( @mysql_query($sql) );
	}

	/**
	 *  returns the last error to occur
	 *
	 */

	function getError() {
		return mysql_error( $this->cnn );
	}

	/**
	 *  returns the last autonumber to be created.  it is assumed
	 *  that one autonumber overwrites the next from a different
	 *  table...  so the tablename is only specified because this
	 *  isn't the case with all DBMS's so they may require this.
	 *
	 *  @param [tableName] the table name (see above)
	 *
	 */

	function getInsertID( $tableName ) {
		return mysql_insert_id( $this->cnn );
	}

	function getDateFunction() {
		return ' now() ';
	}

	public function getUnixTimeStamp( $field ) {
		return " unix_timestamp( $field ) ";
	}

	public function quote( $str ) {
		return addslashes( $str );
	}

	public function getPreLimit( $count ) {}
	
	public function getPostLimit( $count ) {
		return " limit $count ";	
	}

	public function create( $name, $user, $pass ) {
		
		$sql = " create database $name ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

		$sql = " grant all on $name.* to $user@$this->host identified by '$pass' ";
		if ( !$this->update($sql ) )
			Error::fatal( $this->getError(), Error::SYS );

		return true;

	}

	public function drop( $name ) {
		
		$sql = " drop database if exists $name ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );
		
	}

}

/**
 *  class returned when a query is made on the database
 *
 */

class DatabaseQuery {

	var $res = false;

	/**
	 *  constructor
	 *
	 *  @param [res] the result from the mysql query
	 *
	 */

	function DatabaseQuery( $res ) {

		$this->res = $res;

	}

	/**
	 *  tries to fetch the next row from the resultset, if there
	 *  isn't one then false is returned
	 *
	 */

	function fetch() {

		return mysql_fetch_object( $this->res );

	}

}

?>