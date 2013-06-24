<?php

/**
 *  implementation of the Result class for mysql
 *
 */

class Smutty_Database_MySQL_Result extends Smutty_Database_Result {

	private $res = null;

	public function __construct( $res ) {
		$this->res = $res;
	}

	public function fetch() {
		return mysql_fetch_array( $this->res );
	}

	public function fetchAssoc() {
		return mysql_fetch_assoc( $this->res );
	}

	public function fetchObject() {
		return mysql_fetch_object( $this->res );
	}

	public function toArray() {
		$array = array();
		while ( $row = $this->fetch() )
			$array[] = $row;
		return $array;
	}

}

?>