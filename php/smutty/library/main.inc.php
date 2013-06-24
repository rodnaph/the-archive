<?php

// if magic quotes are on for some reason
// then strip slashes cause we don't want em!
// (code originally from php docs)
if ( get_magic_quotes_gpc() ) {
	function stripslashes_deep($value) {
		$value = is_array($value) ?
					array_map('stripslashes_deep', $value) :
					stripslashes($value);	
		return $value;
	}
	$_POST = array_map( 'stripslashes_deep', $_POST );
	$_GET = array_map( 'stripslashes_deep', $_GET );
	$_COOKIE = array_map( 'stripslashes_deep', $_COOKIE );
	$_REQUEST = array_map( 'stripslashes_deep', $_REQUEST );
}

date_default_timezone_set( 'GMT' );

include 'Smutty/Object.class.php';
include 'Smutty/Main.class.php';

define( 'ENIGFORM_SIG', '##ENIGFORM_Sign##' );

$smutty = new Smutty_Main();
$smutty->init();

spl_autoload_register(array( $smutty, 'loadClass' ));

/**
 *  this is the handler for ALL errors generated when smutty
 *  is running.  it overrides the default php error handler
 *
 *  @param Integer $errno severity
 *  @param String $errstr description
 *  @param String $errfile the files full path
 *  @param Integer $errline the line
 *  @param Object $errcon the contect
 *  @return nothing
 *
 */

function smutty_error_handler( $errno, $errstr, $errfile, $errline, $errcon ) {
	if ( class_exists('Smutty_Error') ) {
		$e = Smutty_Error::getInstance();
		$e->errorHandler( $errno, $errstr, $errfile, $errline, $errcon );
	}
	else
		die( "Fatal Error: ($errno) $errstr ($errfile, line $errline)" );
}

/**
 *  a utility for safely extracting a value from an array
 *
 *  @param array $hash the (assoc) array
 *  @param String $key the key (index)
 *  @return value
 *
 */

function v( $hash, $key ) {
	return isset($hash[$key]) ? $hash[$key] : '';
}

/**
 *  safely gets a value from an array, and uses the default
 *  if it's not already set
 *
 *  @param array $hash the array to use
 *  @param String $key the key to find
 *  @param Object $default default to use
 *  @return string
 *
 */

function w( $hash, $key, $default ) {
	$value = v( $hash, $key );
	return $value ? $value : $default;
}

