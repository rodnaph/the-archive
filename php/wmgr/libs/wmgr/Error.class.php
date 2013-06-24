<?

/**
 *  this class represents an error that either the user
 *  has generated, or the system has generated.
 *
 */

class Error {

	// format types
	const STD = 1;
	const XML = 2;
	const CMD = 3;
	const STP = 4;

	// error types
	const USR = 1;
	const SYS = 2;

	public $message, $type;

	private static $format = Error::STD;
	private static $warnings = array();

	/**
	 *  class constructor
	 *
	 *  @param [message] the error description
	 *  @param [type] the type of error (user, system)
	 *  @param [format] the format of the output (html, xml)
	 *
	 */

	function __construct( $message, $type = Error::USR ) {
		$this->message = $message;
		$this->type = $type;
	}

	/**
	 *  sets the format that errors will be output as
	 * 
	 *  @param [format] the format to set
	 * 
	 */

	public static function setFormat( $format ) {

		self::$format = $format;

	}

	/**
	 *  static method used to display a fatal error message
	 *
	 *  @param [message] a description of the error
	 *  @param [type] if it is a user/system error
	 *  @param [format] the format for the output (html, xml, etc...)
	 *
	 */

	public static function fatal( $message, $type = Error::USR ) {

		$error = new Error( $message, $type );
		$tpl = new Template();
		$file = false;

		switch ( self::$format ) {
			case Error::XML:
				$file = 'include/error-xml';
				break;
			case Error::CMD:
				$file = 'include/error-cmd';
				break;
			case Error::STP:
				$file = 'setup/error';
				break;
			default:
				$file = 'include/error';
				break;
		}

		$tpl->assign( 'error', $error );
		$tpl->display( "$file.tpl" );

		exit();

	}

	/**
	 *  informs the system a warning message has been raised.  these
	 *  are just stored and can be accessed via the getWarnings()
	 *  function.
	 * 
	 *  @param [message] a description of the warning
	 *  @param [type] the type of error
	 * 
	 */

	public static function addWarning( $message, $type = Error::USR ) {
		
		array_push( self::$warnings, new Error($message,$type) );
 
	}

	/**
	 *  returns any warning messages that have been raised.
	 * 
	 */

	public static function getWarnings() {
		
		return self::$warnings;

	}

}

?>