<?php

/**
 *  handles the reporting of messages from user test cases
 *
 */

class Smutty_Test_Reporter extends Smutty_Test_AbstractReporter {

	/** results */
	private $html = '';

	/**
	 *  a test has failed
	 *
	 *  @param String $message the error message
	 *  @return nothing
	 *
	 */

	function paintFail($message) {

		parent::paintFail($message);

		$breadcrumb = $this->getTestList();
		array_shift($breadcrumb);

		$this->html = "<span class=\"fail\">Fail</span>: " .
			implode(" -&gt; ", $breadcrumb) .
			" -&gt; " . $message . "<br />\n";

	}

	/**
	 *  an exception was raised
	 *
	 *  @param String $message the message
	 *  @return nothing
	 *
	 */

	function paintError( $message ) {

		parent::paintError($message);

		$breadcrumb = $this->getTestList();
		array_shift($breadcrumb);

		$this->html .= "<div><span class=\"fail\">Exception</span>: " .
			implode(" -&gt; ", $breadcrumb) .
            " -&gt; <strong>" . $message . "</strong></div>\n";

	}

	/**
	 *  the footer with the test results
	 *
	 *  @param String $test_name name of the test
	 *  @return nothing
	 *
	 */

	function paintFooter( $test_name ) {

		$colour = ($this->getFailCount() + $this->getExceptionCount() > 0 ? "red" : "green");
		$this->html .=  "<div style=\"" .
			"padding: 8px; margin-top: 1em; background-color: $colour; color: white;" .
			"\">" .
			$this->getTestCaseProgress() . "/" . $this->getTestCaseCount() .
			" test cases complete:\n" .
			"<strong>" . $this->getPassCount() . "</strong> passes, " .
			"<strong>" . $this->getFailCount() . "</strong> fails and " .
			"<strong>" . $this->getExceptionCount() . "</strong> exceptions." .
			"</div>\n" .
			"</body>\n</html>\n";

	}

	/**
	 *  returns the results after the tests have been run
	 *
	 *  @return String the test results
	 *
	 */

	function getResults() {
		return $this->html;
	}

}

?>