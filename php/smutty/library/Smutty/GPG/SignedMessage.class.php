<?php

/**
 *  represents a signed http post request, then provides
 *  some methods for finding out information about it
 *
 */

class Smutty_GPG_SignedMessage extends Smutty_Object {

	/** the original request */
	private $original;

	/** array of mdg body headers */
	private $msgHeaders;

	/** array of msg sig headers */
	private $sigHeaders;

	/** message body */
	private $msgBody;

	/** sig body */
	private $sigBody;

	/**
	 *  constructor
	 *
	 *  @param String $data the signed message data
	 *  @return nothing
	 *
	 */

	public function __construct( $data ) {
		$this->original = $data;
		$this->msgHeaders = array();
		$this->sigHeaders = array();
		$this->msgBody = '';
		$this->sigBody = '';
		$this->processMessage( $data );
	}

	/**
	 *  returns this messages text, all of it
	 *
	 *  @return String the message text
	 *
	 */

	public function getText() {
		return $this->original;
	}

	/**
	 *  processes a complete signed message block
	 *
	 *  @param String $data the message data
	 *  @return nothing
	 *
	 */

	private function processMessage( $data ) {

		$sigStart = '-----BEGIN PGP SIGNATURE-----';
		$matches = preg_split(
			"/$sigStart/", $data
		);

		// the message section
		$this->processSection( 'SIGNED MESSAGE',
			$matches[0], $this->msgBody,
			$this->msgHeaders
		);

		// the sig section
		$this->processSection( 'SIGNATURE',
			$sigStart . $matches[1],
			$this->sigBody, $this->sigHeaders
		);

	}

	/**
	 *  processes a section of a message (start tag, headers and body)
	 *
	 *  @param String $tag the tag we're expecting
	 *  @param String $data the section data
	 *  @param String $body section body variable to set
	 *  @param array $headers section headers to set
	 *  @return nothing
	 *
	 */

	private function processSection( $tag, $data, &$body, &$headers ) {

		$lines = preg_split( '/\n/', $data );

		// check start line matches
		$line = array_shift( $lines );
		if ( !preg_match("/-----BEGIN PGP $tag-----/",$line) )
			return;

		// now start matching headers
		while ( $lines ) {
			$line = array_shift( $lines );
			if ( preg_match('/^$/',$line) ) break;
			preg_match( '/^(\w+): (.+)$/', $line, $matches );
			if ( self::isValidHeader($matches[1],$matches[2]) )
				$headers[ $matches[1] ] = $matches[2];
		}

		// now the data body
		foreach ( $lines as $line ) {
			if ( preg_match('/^-----END PGP/',$line) ) break;
			$body .= $line;
		}

	}

	/**
	 *  checks a header is ok, ie it doesn't contain
	 *  invalid chars, and is one of the ones defined
	 *  in the spec.
	 *
	 *  @param String $name the name to check
	 *  @param String $value the value to check
	 *  @return boolean if header is valid
	 *
	 */

	private static function isValidHeader( $name, $value ) {

		// check name
		$names = array(
			'Version' => 1,
			'Comment' => 1,
			'MessageID' => 1,
			'Hash' => 1,
			'Charset' => 1
		);
		if ( !$names[$name] )
			return false;

		// check value
		// TODO?  what's valid/invalid?

		// tests passed, all ok
		return true;

	}

	/**
	 *  returns the body of the request
	 *
	 *  @return String the message body
	 *
	 */

	public function getMessageBody() {
		return $this->msgBody;
	}

}

?>