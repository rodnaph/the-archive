<?

/**
 *  this abstract class lays down the template that any database
 *  connection classes must implement.
 *
 */

abstract class Database_WMgr {

	/**
	 *  connects to the database server.  note that the database name
	 *  field is optional.
	 * 
	 *  @param [host] the host to connect to
	 *  @param [user] the user to connect as
	 *  @param [pass] the users password
	 *  @param [name] (optional) name of a database to use
	 * 
	 */

	public abstract function connect( $host, $user, $pass, $name = false );

	/**
	 *  disconnects from the database
	 * 
	 */

	public abstract function disconnect();

	/**
	 *  selects a database to use, this obviously requires a connection
	 *  to the database server.
	 * 
	 *  @param [name] the name of the database
	 * 
	 */

	public abstract function select( $name );

	/**
	 *  performs a query on the database and returns the resultset
	 * 
	 *  @param [sql] the sql for the query
	 * 
	 */

	public abstract function query( $sql );

	/**
	 *  executes the specified sql on the database and returns a
	 *  boolean indicating success or failure.
	 * 
	 *  @param [sql] the sql to execute
	 * 
	 */

	public abstract function update( $sql );

	/**
	 *  returns a description of the last error to occur
	 * 
	 */

	public abstract function getError();

	/**
	 *  returns the last auto-number created.  you need to specify
	 *  the table to fetch this information for as some RDBMS's need
	 *  it (as they can return info per-table), but due to limitations
	 *  of others you can only assume that one ID is kept database-wide.
	 * 
	 *  @param [tableName] name of table insert was on
	 * 
	 */

	public abstract function getInsertID( $tableName );

	/**
	 *  returns an sql snippet for fetching the current date
	 * 
	 */

	public abstract function getDateFunction();

	/**
	 *  returns an sql snippet for creating a unix timestamp from the
	 *  specified field.
	 * 
	 *  @param [field] the field use
	 * 
	 */

	public abstract function getUnixTimeStamp( $field );

	/**
	 *  escapes quotes in the specified string (some db's use a backslash,
	 *  others use two quotes)
	 * 
	 *  @param [str] the string to escape
	 * 
	 */

	public abstract function quote( $str );

	/**
	 *  returns an sql snippet which is placed at the START of queries
	 *  which will limit their resultset.
	 * 
	 *  @param [count] the number of rows to limit to
	 * 
	 */

	public abstract function getPreLimit( $count );

	/**
	 *  returns an sql snippet which is placed at the END of queries
	 *  which will limit their resultset.
	 * 
	 *  @param [count] the number of rows to limit to
	 * 
	 */
	
	public abstract function getPostLimit( $count );

	/**
	 *  executes sql to create a database and give full access to a user
	 *  identified by this username and password.  you will probably need
	 *  to have connected to the database server as an administrator.
	 * 
	 *  @param [name] the name of the database to create
	 *  @param [user] the name of the user account to create
	 *  @param [pass] the users password
	 * 
	 */

	public abstract function create( $name, $user, $pass );

	/**
	 *  drops a database if it exists
	 * 
	 *  @param [name] the name of the database to drop
	 * 
	 */
	
	public abstract function drop ( $name );

	/**
	 *  runs a script on the database
	 * 
	 *  @param [filename] the filename of the script to run
	 * 
	 */

	public function runScript( $filename ) {
		
		// open file and read contents
		$f = fopen( $filename, 'r' );
		$sql = fread( $f, filesize($filename) );
		fclose( $f );
		
		// split the file into it's commands and
		// run them one by one.
		$tok = strtok( $sql, ';' );
		while ( $tok !== false ) {
			$this->update( $tok );
			$tok = strtok( ';' );
		}

	}

}

?>