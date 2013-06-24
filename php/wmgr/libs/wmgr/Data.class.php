<?

/**
 *  this is a utility class for untainting and mangling data
 *  in various ways.
 *
 */

class Data {

	const INT = 1;
	const STR = 2;
	const ARR = 3;

	/**
	 *  this function tries to get an integer from a string.  if
	 *  there is no integer then the empty string is returned
	 *
	 *  @param [str] the string to use
	 *
	 */

	public static function getInt( $str ) {

		return preg_match('/^[0-9]+$/',$str) ? $str : '';

	}

	/**
	*  this function can be used to check that required fields
	*  have been given a value.  if any are found to be empty
	*  then an error occurs, the user is informed, and execution
	*  stops.
	*
	*  @param [required] a name=>value hash or fields and data/type pairs
	*  @param [data] the data array (usually $_GET or $_POST)
	*
	*/

	public static function checkRequiredFields( $required, $data ) {

		foreach ( $required as $key => $values ) {

			$name = $values[0];
			$type = $values[1];
			$value = $data[ $key ];

			// fetch data by type
			switch ( $type ) {
				case Data::INT:
					$value = Data::getInt($value);
					break;
				case Data::STR: /* nothing */
				case Data::ARR: /* nothing */
					break;
				default:
					Error::fatal( "invalid data type specified for '$key'", Error::SYS );
			}

			if ( !$value )
				Error::fatal( "you missed the '$name' field" );

		}

	}

}

?>