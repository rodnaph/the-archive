<?php

/**
 *  this is an abstract class that needs to be implemented by
 *  each of the database drivers.  an instance of this object
 *  should be returned by the drivers "query()" method
 *
 */

abstract class Smutty_Database_Result extends Smutty_Object {

	/**
	 *  constructor.  takes a result from the database (whichever
	 *  one is current)
	 *
	 *  @param mysql_result $res db resultset
	 *  @return nothing
	 *
	 */

	public abstract function __construct( $res );

	/**
	 *  tries to fetch the next record as an array, false if
	 *  there isn't anything to fetch
	 *
	 *  @return array
	 *
	 */

	public abstract function fetch();

	/**
	 *  tries to fetch the next record as a hash, false if
	 *  there isn't anything to fetch
	 *
	 *  @return hash
	 *
	 */

	public abstract function fetchAssoc();

	/**
	 *  tries to fetch the next record as an object, false if
	 *  there isn't anything to fetch
	 *
	 *  @return Object
	 *
	 */

	public abstract function fetchObject();

	/**
	 *  returns the rows in this resultset as an array
	 *
	 *  @return array
	 *
	 */

	public abstract function toArray();

}

?>