<?

/**
 *  this function handles the includion of class
 *  files when they are needed.
 *
 *  @param [className] the name of the class to load
 *
 */

function __autoload( $className ) {

	// database classes have a special naming convention
	$classFile = $className;
	if ( $className == 'Database' )
		$classFile = 'Database_' . DB_TYPE;

	$classPath = "libs/wmgr/$classFile.class.php";
	if ( preg_match('/Test$/',$className) )
		$classPath = "tests/$classFile.php";

	if ( !file_exists($classPath) )
		Error::fatal( "error loading class '$className'", Error::SYS );
	else
		include_once $classPath;

}

// database types
define( 'DB_MYSQL', 'MySQL' );
define( 'DB_MSSQL', 'MSSQL' );

?>