<?

class FolderItem {
	
	const FILE = 1;
	const FOLDER = 2;

	public $id, $name, $type;

	public function __construct( $id, $name, $type ) {
		$this->id = $id;
		$this->name = $name;
		$this->type = $type;
	}

}

?>