<?php

/**
 *  an implementation of the database class for MySQL
 *
 */

class Smutty_Database_MySQL extends Smutty_Database {

	/** the db connection */
	var $cnn = null;

	function connect() {
		$cfg = Smutty_Config::getInstance();
		$this->cnn = mysql_connect(
			$cfg->get('db.host'),
			$cfg->get('db.username'),
			$cfg->get('db.password')
		);
		mysql_select_db( $cfg->get('db.name'), $this->cnn );
	}

	function query( $sql ) {
		$res = mysql_query( $sql, $this->cnn );
		return $res ? new Smutty_Database_MySQL_Result($res) : false;
	}

	function update( $sql ) {
		return mysql_query($sql,$this->cnn) ? true : false;
	}

	function escape( $string ) {
		$string = preg_replace( '/\\\\/', '\\\\\\\\', $string );
		$string = preg_replace( '/\'/', '\\\'', $string );
		return $string;
	}

	function getInsertId( $table ) {
		return mysql_insert_id( $this->cnn );
	}

	function getError() {
		return mysql_error( $this->cnn );
	}

	function getCurrentDate() {
		return date( $this->getDateFormat() . ' h:i:s' );
	}

	function getFieldsSql( $table ) {
		return " desc `$table` ";
	}

	function getDateFormat() {
		return 'Y-m-d';
	}

	function script( $file ) {
		$cfg = Smutty_Config::getInstance();
		$user = $cfg->get( 'db.username' );
		$pass = $cfg->get( 'db.password' );
		$name = $cfg->get( 'db.name' );
		system( "mysql -u \"$user\" " .
				" --password=\"$pass\" " .
				" -D \"$name\" " .
				" -e \"source $file;\" " );
	}

}

?>