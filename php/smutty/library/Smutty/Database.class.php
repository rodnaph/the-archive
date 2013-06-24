<?php

/**
 *  this is the base class which all database implementations need
 *  to extend and implement.  it controls access to these implementations
 *  however and getting a db handle should be done by using the
 *  {@link getInstance() getInstance()} method.
 *
 */

abstract class Smutty_Database extends Smutty_Object {

	/** singleton */
	private static $instance = null;

	/**
	 *  method for getting a handle to the current database
	 *  connection.  of none has been created then this will
	 *  try and read the config to find out what and how to create.
	 *
	 *  @return Smutty_Database the singleton
	 *
	 */

	public static function &getInstance() {
		// need to use === as false means we've tried to
		// connect but something has gone wrong!
		if ( self::$instance === null ) {
			$cfg = Smutty_Config::getInstance();
			switch ( strtolower($cfg->get('db.type')) ) {
				case 'mysql':
					self::$instance = new Smutty_Database_MySQL();
					break;
				default:
					self::$instance = false; // need to set this to avoid infinite loop of
									// code in the error handler trying to get
									// a db handle.
					Smutty_Error::warning( 'unknown database type db.type in app.cfg', 'SmuttyConfig' );
			}
			// connect to db if we can
			if ( self::$instance )
				self::$instance->connect();
		}
		return self::$instance;
	}

	/**
	 *  connects to the database.  db config information could be
	 *  db independent so this method must read this info from
	 *  the Smutty_Config class itself.
	 *
	 *  @return boolean indicating success
	 *  @return nothing
	 *
	 */

	protected abstract function connect();

	/**
	 *  executes a query on the database.  it should return an
	 *  class which extends the Smutty_Database_Result class
	 *
	 *  @param String $sql the query to execute
	 *  @return Smutty_Database_Result query result
	 *
	 */

	public abstract function query( $sql );

	/**
	 *  executes an sql statement on the database and returns a
	 *  boolean indicating if it went well or not
	 *
	 *  @param String $sql the query to execute
	 *  @return boolean success
	 *
	 */

	public abstract function update( $sql );

	/**
	 *  takes a string and escapes any characters in it that need
	 *  to be for the current database
	 *
	 *  @param String $string the string to escape
	 *  @return String escaped string
	 *
	 */

	public abstract function escape( $string );

	/**
	 *  returns the auto generated id for the last record inserted.
	 *  for compat you need to specify the table the record was
	 *  inserted for (though this is not used for some dbs)
	 *
	 *  @param String $table table record was inserted into
	 *  @return int the inserted id
	 *
	 */

	public abstract function getInsertId( $table );

	/**
	 *  returns the last error to occur
	 *
	 *  @return String desc of last error
	 *
	 */

	public abstract function getError();

	/**
	 *  returns the current date/time, formatted properly for the
	 *  current database
	 *
	 *  @return String current datetime string
	 *
	 */

	public abstract function getCurrentDate();

	/**
	 *  returns the sql used to eatract field information
	 *
	 *  the resultset should have the fields:
	 *    - name (field name)
	 *    - type (field type)
	 *    - nullable (yes/no string)
	 *
	 *  @param String $table the table to get fields for
	 *  @return String sql string
	 *
	 */

	public abstract function getFieldsSql( $table );

	/**
	 *  returns the date format for this db.  the format should
	 *  be ready for the date() function to use
	 *
	 *  @return String date format string
	 *
	 */

	public abstract function getDateFormat();

	/**
	 *  run an sql script against the database.  returns a
	 *  boolean indicating success.
	 *
	 *  @param String $file the script to run
	 *  @return boolean if script ran ok
	 *
	 */

	public abstract function script( $file );

}

?>
