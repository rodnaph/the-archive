<?

class Folder {

	/**
	 *  returns the items in a folder (items means files and sub-folders)
	 *  not in any particular order.
	 * 
	 *  @return array of FolderItem's
	 * 
	 *  TODO: filter on users groups
	 * 
	 */

	public static function getItems( $folderID = false ) {
		
		global $db;
		
		$items = array();
		$folderSQL = ( $folderID ) ? " = '$folderID' " : ' is null ';
		$sql = " select d.id, d.name, " . FolderItem::FILE . " as type
				from docs d
				where folder_id $folderSQL
				union all
				select f.id, f.name, " . FolderItem::FOLDER . "
				from doc_folders f
				where parent_id $folderSQL ";
		if ( !$res = $db->query($sql) )
			Error::fatal( $db->getError(), Error::SYS );

		while ( $row = $res->fetch() )
			$items[] = new FolderItem( $row->id, $row->name, $row->type );

		return $items;
	
	}

}

?>