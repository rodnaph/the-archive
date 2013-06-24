<?

class Smutty_UtilsTest extends Smutty_Test {

	function testStrToHash() {
		$x = array( one => 1, two => 2 );
		$y = 'one,1,two,2';
		$hash = Smutty_Utils::strToHash( $y );
		// check size
		$this->assertTrue( sizeof($x) == sizeof($hash) );
		// check elems
		foreach ( $x as $a => $b )
			$this->assertTrue( $hash[$a] == $b );
	}

	function testCopyAssoc() {
		$x = array( one => 1, two => 2 );
		$y = Smutty_Utils::copyAssoc( $x );
		// check length
		$this->assertTrue( sizeof($x) == sizeof($y) );
		// check elements
		foreach ( $x as $a => $b )
			$this->assertTrue( $y[$a] == $b );
	}

	function testGetUniqueId() {
		$id = Smutty_Utils::getUniqueId();
		// check string is 10 chars
		$this->assertTrue( strlen($id) == 10 );
	}

	function testPluralize() {
		$this->assertTrue(
			Smutty_Utils::pluralize('entry') == 'entries'
		);
	}

}

?>