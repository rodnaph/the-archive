<?php

/**
 *  this is the root of all classes in smutty.  it provides
 *  the basic functionality for error reporting that we
 *  require.
 *
 */

class Smutty_Object {

	/**
	 *  converts this object to a string
	 *
	 *  @return String describes the class
	 *
	 */

	public function __toString() {
		return 'Smutty_Object: ' . get_class($this);
	}

}

?>