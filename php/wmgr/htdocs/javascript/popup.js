
var POPUP_ID = 'qwertyuiop';
var PO_element = null;
var PO_hideTimeout = null;

/**
 *  this function will hide the popup menu
 *
 */

function PO_hidePopup() {
	PO_hideClear();
	PO_element.style.display = 'none';
}

/**
 *  clears the timeout set to hide the popup
 *
 */

function PO_hideClear() {
	if ( PO_hideTimeout != null )
		clearTimeout( PO_hideTimeout );
	PO_hideTimeout = null;
}

/**
 *  sets a timeout to check if it's time to hide popup
 *
 */

function PO_hideCheck( iDelay ) {
	PO_hideClear();
	PO_hideTimeout = setTimeout(
		PO_hidePopup,
		iDelay / 1 ? iDelay : 300
	);
}

/**
 *  represents an item on the popup menu
 *
 *  @param [sText] the item text
 *  @param [sAction] the HREF action to perform
 *
 */
 
function PopupItem( sText, sAction ) {

	var sText = sText;
	var sAction = sAction;

	/**
	 *  returns the text for this item
	 *
	 */

	this.getText = function() {
		return sText;
	};

	/**
	 *  returns the action to perform for this item
	 *
	 */

	this.getAction = function() {
		return sAction;
	};

}

/**
 *  this is a popup object that can be used any time to
 *  easily create popup menus.
 *
 *  @param [eAnchor] the anchor element to attach the popup to
 *
 */

function Popup( eAnchor ) {

	var eAnchor = eAnchor;
	var items = new Array();

	// init popup element if needed
	if ( !PO_element ) {
		PO_element = document.getElementById( POPUP_ID );
		PO_element.className = 'PopupMenu';
		PO_element.onmouseout = PO_hideCheck;
	}

	/**
	 *  adds an item to the popup menu
	 *
	 *  @param [sText] the text to display
	 *  @param [sAction] the action to perform for the href
	 *
	 */

	this.addItem = function( sText, sAction ) {
		items.push( new PopupItem(sText,sAction) );
	};

	/**
	 *  call this to show the popup menu
	 *
	 */

	this.show = function() {

		// add items
		clearElement( PO_element );
		for ( var i=0; i<items.length; i++ ) {
			var item = items[ i ];
			var eItem = document.createElement( 'a' );
			eItem.href = item.getAction();
			eItem.onclick = PO_hidePopup;
			eItem.onmouseover = PO_hideClear;
			eItem.appendChild(
				document.createTextNode(item.getText())
			);
			PO_element.appendChild( eItem );
		}

		// if no items add a 'no items' message
		if ( !items.length )
			PO_element.appendChild(
				document.createTextNode('Nothing...')
			);

		// then show.  the user has 1 second to move their mouse
		// over the popup before it will close.  good idea?!?
		PO_element.style.top = (getYPos(eAnchor) + 12) + 'px';
		PO_element.style.left = getXPos(eAnchor) + 'px';
		PO_element.style.display = 'block';
		PO_hideCheck( 1000 );

	};

}

// write the popup element we'll use
document.writeln( '<div id="' + POPUP_ID + '"></div>' );
