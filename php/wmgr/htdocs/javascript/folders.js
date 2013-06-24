
function FolderItem( id, name, type ) {
	this.id = id;
	this.name = name;
	this.type = type;
}

/**
 *  sorts FolderItem's alphabetically
 * 
 *  NB: there *must* be a better way to do this, but i was tired and
 *  in a rush when i had to get it done.
 * 
 */

function sortItems( a, b ) {

	var items = new Array( a.name, b.name );
	items = items.sort();

	return ( items[0] == a.name ? -1 : 1 );

}

/**
 *  handles the return of the query to refresh the folder display, it
 *  then clears the current display and draws the new contents.
 * 
 *  @param [oRequest] the request object
 *  @param [iParentID] the parent id (maybe null)
 * 
 */

function refreshFolderViewHandler( oRequest, iParentID ) {

	var oXml = oRequest.responseXML;
	var eRoot = oXml.documentElement;
	var items = eRoot.getElementsByTagName( 'item' );
	var aItems = new Array();
	var eUL = document.getElementById( 'FolderItems' );

	// create the array of FolderItems
	for ( var i=0; i<items.length; i++ ) {
		var eItem = items[ i ];
		var iID = eItem.getAttribute( 'id' );
		var sName = getChildValue( eItem, 'name' );
		var iType = eItem.getAttribute( 'type' );
		aItems.push( new FolderItem(iID,sName,iType) );
	}

	// sort the items alphabetically
	aItems = aItems.sort( sortItems );

	// add parent folder if there is one
	if ( iParentID )
		aItems.unshift( new FolderItem(iParentID,'..',TYPE_FOLDER) );

	// clear current items
	clearElement( eUL );

	// first do folders
	for ( var i=0; i<aItems.length; i++ ) {
		var oItem = aItems[ i ];		
		if ( oItem.type == TYPE_FOLDER ) {
			
			var eLI = document.createElement( 'li' );
			var eLink = document.createElement( 'a' );
			var eImg = document.createElement( 'img' );

			eImg.src = URL_BASE + '/images/12x12/group.png';
			
			eLink.href = 'javascript:refreshFolderView(\'' + oItem.id + '\');';
			eLink.appendChild( document.createTextNode(oItem.name) );
			
			eLI.appendChild( eImg );
			eLI.appendChild( eLink );
			eUL.appendChild( eLI );

		}
	}

	// then files
	for ( var i=0; i<aItems.length; i++ ) {
		var oItem = aItems[ i ];		
		if ( oItem.type == TYPE_FILE ) {
			
			var eLI = document.createElement( 'li' );
			var eLink = document.createElement( 'a' );
			
			eLink.href = 'download.php?id=' + escape(oItem.id);
			eLink.appendChild( document.createTextNode(oItem.name) );
			eLI.appendChild( eLink );
			eUL.appendChild( eLI );

		}
	}

}

/**
 *  call this to refresh the display for a particular folder
 * 
 */

function refreshFolderView( iFolderID ) {

	var url = URL_BASE + '/xml/docs/getFolderItems.xml.php?folder_id=' + ( iFolderID ? escape(iFolderID) : '' );

	xmlQuery( url, refreshFolderViewHandler, iFolderID );

}
