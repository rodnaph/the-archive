<?php

class Database {

  // vars
  var $connected = FALSE;
  var $result;
  var $connection;

  // errors
  var $CONN = 'Error Connecting To Database';
  var $NO_CONN = 'Not Connected To Database';
  var $NO_DATA = 'There was no data from the last query';

  /**
   *  connects to the database
   */

  function connect( $user, $pass, $name ) {

    $this->connection = @mysql_connect( 'localhost', $user, $pass );

    if ( !$this->connection ) $this->error( $this->CONN );

    mysql_select_db( $name, $this->connection );
    $this->connected = TRUE;

  }

  /**
   *  sends a query to the database
   */

  function query( $sql ) {

    if ( !$this->connected ) $this->error( $this->NO_CONN );

    $this->result = mysql_query( $sql, $this->connection );

  }

  /**
   *  returns the next row of data as an associative array
   */

  function next_row() {

    if ( !$this->connected )
      $this->error( $this->NO_CONN );

    return mysql_fetch_array( $this->result );

  }

  /**
   *  sets pointer to certain offset
   */

  function seek( $position ) {

    if ( !$this->connected ) $this->error( $this->NO_CONN );
    if ( !$this->result ) $this->error( $this->NO_DATA );

    mysql_data_seek( $this->result, $position );

  }

  /**
   *  ! INTERNAL !
   *  signals an error and croaks
   */

  function error( $message ) {

    echo '<b>Database Error:</b> ' . $message;
    exit();

  }

}

?>