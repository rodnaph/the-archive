<?php

/**
 *  this is an abstract class which smutty test reports
 *  must implement
 *
 */

abstract class Smutty_Test_AbstractReporter extends SimpleReporter {

	/**
	 *  returns the output from the reporter after all
	 *  the tests have been run.
	 *
	 *  @return String the test results
	 *
	 */

	public abstract function getResults();

}

?>