
var smutty_tabPageActive = null;

/**
 *  shows a page from a tag group
 *
 *  @param sId the id of the page to show
 *  @return nothing
 *
 */

function smutty_tabPageShow( sId ) {
	// deselect and hide old tab
	if ( smutty_tabPageActive != null ) {
		$( smutty_tabPageActive ).hide();
		$( 'TabPageLink' + smutty_tabPageActive ).removeClassName( 'currentTab' );
	}
	// now show the requested tab
	$( sId ).show();
	$( 'TabPageLink' + sId ).addClassName( 'currentTab' );
	smutty_tabPageActive = sId;
}
