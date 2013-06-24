<?

/**
 *  a class for connecting to, and interacting with MySQL
 *  databases.
 *
 */

class Database extends Database_WMgr {

	var $cnn = false;

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

		$this->cnn = mssql_connect( $host, $user, $pass );

		if ( $this->cnn && $name )
			$this->select( $name );

		return ( $this->cnn );

	}
	
	public function disconnect() {
		
		mssql_close( $this->cnn );
		$this->cnn = null;
		
	}

	public function select( $name ) {

		mssql_select_db( $name, $this->cnn );

	}

	/**
	 *  queries the database with the specified sql
	 *
	 *  @param [sql] the sql for the query
	 *
	 */

	function query( $sql ) {

		$res = mssql_query( $sql, $this->cnn );

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
		return ( @mssql_query($sql) );
	}

	/**
	 *  returns the last error to occur
	 *
	 */

	function getError() {
		return mssql_get_last_message( $this->cnn );
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
		$tableName = $this->quote( $tableName );
		$sql = " select ident_current('$tableName') as newid ";
		if ( !$res = $this->query($sql) )
			Error::fatal( $this->getError(), Error::SYS );
		$row = $res->fetch();
		return $row->newid;
	}

	function getDateFunction() {
		return ' getdate() ';
	}

	public function getUnixTimeStamp( $field ) {
		return " DATEDIFF(s, '19700101', $field )  ";
	}

	public function quote( $str ) {
		return addslashes( $str );
	}

	public function getPreLimit( $count ) {
		return " top $count ";
	}
	
	public function getPostLimit( $count ) {}

	public function create( $name, $user, $pass ) {
	
		$sql = " create database [$name] ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

		$sql = " create login [$user] with password = '$pass' ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

		$sql = " use [$name] ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

		$sql = " create user [$user] from login [$user] ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

		$sql = " sp_addrolemember 'db_owner', '$user' ";
		if ( !$this->update($sql) )
			Error::fatal( $this->getError(), Error::SYS );

	}

	public function drop( $name ) {
		
		$sql = " select 1 " .
				" from sys.databases " .
				" where name = '$name' ";
		if ( !$res = $this->query($sql) )
			Error::fatal( $this->getError(), Error::SYS );
		
		if ( $res->fetch() ) {
			$sql = " drop database [$name] ";
			if ( !$this->update($sql) )
				Error::fatal( $this->getError(), Error::SYS );
		}

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

		return mssql_fetch_object( $this->res );

	}

}

?>