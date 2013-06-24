<?

class Document {

	public $id, $name, $dateCreated, $binSize, $binType;

	private $binData;

	/**
	 *  constructor
	 *
	 *  @param [id] the document id
	 *  @param [name] the document name
	 *  @param [user] the user who uploaded the document
	 *  @param [dateCreated] the date it was uploaded
	 *  @param [binSize] it's size in bytes
	 *  @param [binType] it's mine type
	 *
	 */

	public function __construct( $id, $name, $user, $dateCreated, $binSize, $binType ) {

		$this->id = $id;
		$this->name = $name;
		$this->user = $user;
		$this->dateCreated = $dateCreated;
		$this->binSize = $binSize;
		$this->binType = $binType;

		$this->binData = null;

	}

	/**
	 *  returns the data for this document
	 *
	 */

	public function getData() {

		global $db;

		if ( $this->binData == null ) {
			$sql = " select d.bin_data
				from doc_data d
				where d.doc_id = '$this->id' ";
			if ( !$res = $db->query($sql) )
				Error::fatal( $db->getError(), Error::SYS );
			if ( !$row = $res->fetch() )
				Error::fatal( 'no data found', Error::SYS );
			$this->binData = $row->bin_data;
		}

		return $this->binData;

	}

	/**
	 *  adds a document to the database
	 *
	 *  @param [name] the document name
	 *  @param [binSize] it's size in bytes
	 *  @param [binType] it's mime type
	 *  @param [binData] the document data
	 *
	 */

	public static function create( $name, $groupID, $binSize, $binType, $binData ) {

		global $db, $user;

		$dateCreated = $db->getDateFunction();
		$sql = " insert into docs ( name, user_id, group_id, date_created, bin_size, bin_type )
			values ( '$name', '$user->id', '$groupID', $dateCreated, '$binSize', '$binType' ); ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		$id = $db->getInsertID( 'docs' );
		$binData = addSlashes( $binData );
		$sql = " insert into doc_data ( doc_id, bin_data )
			values ( '$id', '$binData' ); ";
		if ( !$db->update($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		return $id;

	}

	/**
	 *  uploads a bunch of documents and returns an
	 *  array with their id's
	 *
	 *  @param [docName] the name of the document form element array
	 *
	 */

	public static function uploadDocuments( $groupID, $docName ) {

		$docs = array();

		foreach ( $_FILES['doc']['error'] as $doc => $error ) {

			if ( $error == UPLOAD_ERR_OK ) {

				$name = $_FILES['doc']['name'][$doc];
				$type = $_FILES['doc']['type'][$doc];
				$size = $_FILES['doc']['size'][$doc];
				$path = $_FILES['doc']['tmp_name'][$doc];
				$f = fopen( $path, 'r' );
				$data = fread( $f, filesize($path) );
				fclose( $f );
				$docID = Document::create(
					$name, $groupID, $size, $type, $data
				);

				array_push( $docs, $docID );

			}

		}

		return $docs;

	}

	/**
	 *  loads a document by id
	 * 
	 *  TODO: filter the document by the users groups to make sure
	 *  that they have access to it.
	 * 
	 */

	public static function load( $id ) {

		global $db;

		$dateCreated = $db->getUnixTimeStamp( 'd.date_created' );
		$sql = " select d.id, d.name, $dateCreated as dateCreated,
				d.bin_size, d.bin_type,
				u.id as userID, u.name as userName, u.email as userEmail
			from docs d
				inner join users u
				on u.id = d.user_id
			where d.id = '$id' ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );
		if ( $row = $res->fetch() )
			return new Document(
				$row->id, $row->name,
				new User($row->userID,$row->userName,$row->userEmail),
				$row->dateCreated, $row->bin_size, $row->bin_type
			);
		else return false;

	}

}

?>