<?

class Icon {

	public $id, $name, $filename;

	/**
	 *  constructor
	 *
	 *  @param [id] icon id
	 *  @param [name] the icon name
	 *  @param [filename] the icons filename
	 *
	 */

	public function __construct( $id, $name, $filename ) {

		$this->id = $id;
		$this->name = $name;
		$this->filename = $filename;

		if ( !$this->id ) Error::fatal( 'no icon id' );
		if ( !$this->name ) Error::fatal( 'no icon name' );
		if ( !$this->filename ) Error::fatal( 'no icon filename' );

	}

}

?>