<?

class PageHistory {

	public $id, $body, $user, $dateEdited;

	/**
	 *  constuctor
	 *
	 *  @param [id] the page history id
	 *  @param [body] the page body
	 *  @param [user] the user who edited the page
	 *  @param [dateEdited] the date it was edited
	 *
	 */

	public function __construct( $id, $body, $user, $dateEdited ) {

		$this->id = Data::getInt( $id );
		$this->body = $body;
		$this->user = $user;
		$this->dateEdited = Data::getInt( $dateEdited );

		// check we were set up ok
		if ( !$this->id ) Error::fatal('bad id for page history',Error::SYS);
		if ( !$this->user ) Error::fatal('bad user for page history',Error::SYS);
		if ( !$this->dateEdited ) Error::fatal('bad date for page history',Error::SYS);

	}

}

?>