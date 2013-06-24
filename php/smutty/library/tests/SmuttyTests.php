<?

$suite = new Smutty_Test_Suite();

$d = opendir( 'library/tests' );
while ( $f = readdir($d) )
	if ( substr($f,-8) == 'Test.php' )
		$suite->addTest( substr($f,0,strlen($f)-4) );

$suite->run();

?>
