
/**
 *  handles the selection of a page from
 *  the page explorer.
 * 
 *  @param [oPage] the selected page
 * 
 */

function explorerSelectionHandler( oItem ) {

	var eID = document.getElementById( 'ParentID' );
	var eName = document.getElementById( 'ParentName' );

	if ( oItem == null ) {
		eID.value = '';
		eName.value = '';
	}
	
	else {
		eID.value = oItem.getID();
		eName.value = oItem.getName();
	}

}
