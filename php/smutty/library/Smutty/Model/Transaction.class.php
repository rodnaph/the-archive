<?php

/**
 *  this class allows models to be grouped together into a
 *  "transaction", which means you can deal with them as
 *  a single unit rather than saving/validating them
 *  all individually.
 *
 */

class Smutty_Model_Transaction extends Smutty_Object {

	/** the transactions models */
	var $models;

	/** any errors found */
	var $errors;

	/**
	 *  constructor
	 *
	 *  @return nothing
	 *
	 */

	function Smutty_Model_Transaction() {
		$this->models = array();
		$this->errors = array();
	}

	/**
	 *  adds a model to the transaction
	 *
	 *  @param Smutty_Model $model model to add
	 *  @return nothing
	 *
	 */

	function add( &$model ) {
		$this->models[] =& $model;
	}

	/**
	 *  checks if all the models in the transaction are valid
	 *
	 *  @return boolean transaction validity
	 *
	 */

	function isValid() {

		// check models for errors
		$isValid = true;
		$this->errors = array();
		$size = sizeof( $this->models );

		// NEED to use "for" not "foreach" cause of refs
		for ( $i=0; $i<$size; $i++ )
			if ( !$this->models[$i]->isValid() ) {
				$isValid = false;
				$this->errors = array_merge(
					$this->errors,
					$this->models[$i]->getErrors()
				);
			}

		return $isValid;

	}

	/**
	 *  checks all the models in the transaction for validity
	 *  before saving them.
	 *
	 *  @return boolean if transaction saved
	 *
	 */

	function save() {

		if ( !$this->isValid() )
			return false;

		// NEED to use "for" not "foreach" cause of refs
		$size = sizeof( $this->models );
		for ( $i=0; $i<$size; $i++ )
			$this->models[$i]->save();

		return true;

	}

	/**
	 *  returns any errors found when trying to save the transaction
	 *
	 *  @return array array of error strings
	 *
	 */

	function getErrors() {
		return $this->errors;
	}

}

?>