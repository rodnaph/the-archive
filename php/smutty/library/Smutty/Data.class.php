<?php

/**
 *  this class controls access to GET, POST and SERVER data.  it's
 *  getInstance() method will return an instance with the correct
 *  type for the request method (GET/POST), but you can use this
 *  object to control access to any kind of data really.
 *
 */

class Smutty_Data extends Smutty_Object {

	/** internal data store */
	private $data;

	/** is the message signed */
	private $isSigned;

	/** is the signed message verified */
	private $isVerified;

	/** the signed message */
	private $signedMessage;

	/** singletons */
	private static $instance = null;
	private static $postInstance = null;
	private static $getInstance = null;
	private static $serverInstance = null;

	/**
	 *  constructor.  if you pass in some data then that will
	 *  be used as this objects data, otherwise the object will
	 *  look at the request method to determine get/post
	 *
	 *  @param hash $data optional data to use
	 *  @return nothing
	 *
	 */

	public function __construct( $data = false ) {

		$this->isSigned = false;
		$this->signedMessage = null;
		$this->isVerified = null;;

		if ( $data )
			$this->data = $data;
		else {

			$server = Smutty_Data::getServerData();
			$isPost = ( $server->string('REQUEST_METHOD') == 'POST' );
			$type = $server->string( 'HTTP_X_OPENPGP_TYPE' );

			// check if it's PGP SIGNED
			if ( preg_match('/[SE]/',$type) ) {

				// create message body and signed object
				$data = $isPost ? file_get_contents('php://input') : $server->string('QUERY_STRING');
				$body = $this->createGpgMessageBody( $data );
				$this->signedMessage = new Smutty_GPG_SignedMessage( $body );
				$this->isSigned = true;

			}

			// store data for request
			$this->data = $isPost ? $_POST : $_GET;

		}

	}

	/**
	 *  creates a signed message with the specified data.  the message
	 *  parameters are filled in from the http headers
	 *
	 *  @param String $data data for the message
	 *  @return String a gpg message
	 *
	 */

	private function createGpgMessageBody( $data ) {

		$server = Smutty_Data::getServerData();
		$body = "-----BEGIN PGP SIGNED MESSAGE-----
Hash: " . $server->string('HTTP_X_OPENPGP_DIGEST_ALGO') . "

" . $data . "
-----BEGIN PGP SIGNATURE-----
Version: " . $server->string('HTTP_X_OPENPGP_VERSION') . "

" . $server->string('HTTP_X_OPENPGP_SIG') . "
-----END PGP SIGNATURE------
";

		return $body;

	}

	/**
	 *  indicates if the data is PGP signed
	 *
	 *  @return boolean if the data is signed
	 *
	 */

	public function isSigned() {
		return $this->isSigned;
	}

	/**
	 *  verifies the data's signature (if there is one).  returns
	 *  a boolean indicating if it's good or not.
	 *
	 *  @return boolean if the data is verified
	 *
	 */

	public function isVerified() {

		if ( $this->isVerified == null && $this->isSigned ) {
			$gpg = Smutty_GPG::getInstance();
			$this->isVerified = $gpg->verify(
				$this->signedMessage->getText()
			);
		}

		return $this->isVerified;

	}

	/**
	 *  returns a data object for $_POST
	 *
	 *  @return Smutty_Data post data
	 *
	 */

	public static function &getPostData() {
		if ( self::$postInstance == null )
			self::$postInstance = new Smutty_Data( $_POST );
		return self::$postInstance;
	}

	/**
	 *  returns a data object for $_GET
	 *
	 *  @return Smutty_Data get data
	 *
	 */

	public static function &getGetData() {
		if ( self::$getInstance == null )
			self::$getInstance = new Smutty_Data( $_GET );
		return self::$getInstance;
	}

	/**
	 *  returns a data object for $_SERVER
	 *
	 *  @return Smutty_Data server data
	 *
	 */

	public static function &getServerData() {
		if ( self::$serverInstance == null )
			self::$serverInstance = new Smutty_Data( $_SERVER );
		return self::$serverInstance;
	}

	/**
	 *  used to set values for this object
	 *
	 *  @param String $name name of param
	 *  @param String $value value to set
	 *  @return nothing
	 *
	 */

	public function set( $name, $value ) {
		$this->data[ $name ] = $value;
	}

	/**
	 *  static method for fetching the instance of this class (as
	 *  it's designed to be a singleton)
	 *
	 *  @return Smutty_Data the class instance
	 *
	 */

	public static function &getInstance() {
		if ( self::$instance == null )
			self::$instance = new Smutty_Data();
		return self::$instance;
	}

	/**
	 *  returns the value of the specifed variable as
	 *  an integer (false if it's not valid)
	 *
	 *  @param String $name name of variable to fetch
	 *  @return integer value
	 *
	 */

	public function int( $name ) {
		return Smutty_Data::getInt( v($this->data,$name) );
	}

	/**
	 *  this method can be used staticly to validate data
	 *  data as being an integer.  returns false when invalid.
	 *
	 *  @param String $value the value to validate
	 *  @return integer integer
	 *
	 */

	public static function getInt( $value ) {
		// is this too heavy-weight?
		$badchars = preg_replace( '/[0-9]/', '', '' . $value );
		return $badchars ? false : $value;
	}

	/**
	 *  returns an integer with a padded 0 if it
	 *  is less than 10
	 *
	 *  @param String $name the name of the variable
	 *  @return integer padded integer
	 *
	 */

	public function intPad( $name ) {
		$value = $this->int( $name );
		return ( $value < 10 ) ? "0$value" : $value;
	}

	/**
	 *  returns the value of the specifed variable
	 *  as a string.
	 *
	 *  @param String $name name of variable
	 *  @return string value
	 *
	 */

	public function string( $name ) {
		return v( $this->data, $name );
	}

	/**
	 *  returns an object from the data
	 *
	 *  @param String $name name of variable
	 *  @return object value
	 *
	 */

	public function object( $name ) {
		return isset($this->data[$name]) ? $this->data[$name] : false;
	}

	/**
	 *  returns a data object, which is a new instance of
	 *  this object.  this will be something like args passed
	 *  in from a form using name[value] type args
	 *
	 *  @param String $name the name of the data array
	 *  @return Smutty_Data hash/data/object
	 *
	 */

	public function data( $name ) {
		return new Smutty_Data( v($this->data,$name) );
	}

	/**
	 *  returns the fields that exist in this data model
	 *
	 *  @return array array of field names
	 *
	 */

	public function getFields() {
		$fields = array();
		foreach ( $this->data as $name => $value )
			array_push( $fields, $name );
		return $fields;
	}

	/**
	 *  returns the current date and time formatted as a string
	 *  for use with the database
	 *
	 *  @return String date format
	 *
	 */

	public function getDate() {
		$db = Smutty_Database::getInstance();
		return $db ? $db->getCurrentDate() : 'Y-m-d';
	}

	/**
	 *  checks to see if a value exists (isset)
	 *
	 *  @param String $name name of param to check
	 *  @return boolean if parameter exists
	 *
	 */

	public function exists( $name ) {
		return isset( $this->data[$name] );
	}

}

?>