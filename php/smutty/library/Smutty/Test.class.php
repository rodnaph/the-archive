<?php

include_once 'library/simpletest/unit_tester.php';
include_once 'library/simpletest/reporter.php';

/**
 *  Smutty's own subclass of the SimpleTest UnitTestCase.  it just
 *  adds a few extra nice things that are... well, nice.
 *
 */

class Smutty_Test extends UnitTestCase {

	/**
	 *  this function tests an array of regular expressions
	 *  against a string and asserts that they all match
	 *
	 *  @param String $string the string to match against
	 *  @param String $regexps the regexp's to match
	 *  @return nothing
	 *
	 */

	function assertRegExps( $string, $regexps ) {

		foreach ( $regexps as $regexp )
			$this->assertTrue( preg_match($regexp,$string) );

	}

}

?>