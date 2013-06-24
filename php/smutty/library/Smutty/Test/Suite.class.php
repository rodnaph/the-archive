<?php

include_once 'library/simpletest/unit_tester.php';
include_once 'library/simpletest/reporter.php';

/**
 *  Smutty's subclass of the SimpleTest TestSuite
 *
 */

class Smutty_Test_Suite extends TestSuite {

	/** directory with test cases */
	var $testDir;

	/**
	 *  constructor
	 *
	 *  @param String $testDir directory that holds tests
	 *  @return nothing
	 *
	 */

	function Smutty_Test_Suite( $testDir = 'library/tests' ) {
		$this->testDir = $testDir;
	}

	/**
	 *  adds a test to the suite
	 *
	 *  @param String $name test to add
	 *  @return nothing
	 *
	 */

	function addTest( $name ) {
		parent::addTestFile( "$this->testDir/$name.php" );
	}

	/**
	 *  runs the test suite
	 *
	 *  @return nothing
	 *
	 */

	function run() {

		parent::run( new TextReporter() );

	}

}

?>