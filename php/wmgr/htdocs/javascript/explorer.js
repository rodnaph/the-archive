
var selectedProviderItem = null;

function ProjectProvider( iParentID ) {
	this.getURL = function() {
		return '/xml/projects/explorer/getChildrenForProject.xml.php?' +
			'id=' + iParentID;
	};
	this.getItemProvider = function( oItem ) {
		return new ProjectProvider( oItem.getID() );
	};
	this.getItems = function( eRoot ) {
		var items = eRoot.getElementsByTagName( 'project' );
		var array = new Array();
		for ( var i=0; i<items.length; i++ ) {
			array.push( new ProviderItem(
				items[i].getAttribute('id'),
				getChildValue( items[i], 'name' ),
				( items[i].getAttribute('childCount') > 0 )
			));
		}
		return array;
	};
	this.isSelectable = function() {
		return true;
	};
}

/**
 *  this provider controls the hierarchy of pages.  the group parameter
 *  is for the root node as we need to know which group to fetch the
 *  root nodes for.
 * 
 */

function PageProvider( iParentID, iGroupID ) {
	this.getURL = function() {
		return '/xml/pages/explorer/getChildrenForPage.xml.php?' +
			'id=' + iParentID + '&' +
			'group_id=' + iGroupID;
	};
	this.getItemProvider = function( oItem ) {
		return new PageProvider( oItem.getID() );
	};
	this.getItems = function( eRoot ) {
		var items = eRoot.getElementsByTagName( 'page' );
		var array = new Array();
		for ( var i=0; i<items.length; i++ ) {
			array.push( new ProviderItem(
				items[i].getAttribute('id'),
				getChildValue( items[i], 'name' ),
				( items[i].getAttribute('childCount') > 0 )
			));
		}
		return array;
	};
	this.isSelectable = function() {
		return true;
	};
}

/**
 *  this provider is designed to be the root of a the tree
 *  and displays for each group
 * 
 */

function GroupProvider( iFilter ) {
	this.getURL = function() {
		return '/xml/groups/groupsForUser.xml.php';
	};
	this.getItemProvider = function( oItem ) {
		return new PageProvider( '', oItem.getID() );
	};
	this.getItems = function( eRoot ) {
		var items = eRoot.getElementsByTagName( 'group' );
		var array = new Array();
		for ( var i=0; i<items.length; i++ ) {
			if ( !iFilter || (items[i].getAttribute('id') == iFilter) )
				array.push( new ProviderItem(
					items[i].getAttribute('id'),
					getChildValue( items[i], 'name' ),
					true
				));
		}
		return array;
	};
	this.isSelectable = function() {
		return false;
	};
}

/**
 *  this object should be created by each providers getItems() method
 *  which should return an array of these.
 * 
 *  @param [iID] the item id
 *  @param [sName] the item name
 *  @param [bChildren] boolean indicating if this item has children
 * 
 */

function ProviderItem( iID, sName, bChildren ) {
	this.getID = function() {
		return iID;
	};
	this.getName = function() {
		return sName;
	};
	this.hasChildren = function() {
		return bChildren;
	};
};

/**
 *  this object represents a tree node and handles everything to do
 *  with drawing and toggling it's display.  it uses the specified
 *  provider to do tree-specific stuff.
 * 
 */

function ExplorerNode( eContainer, oProvider ) {
	
	var oSelf = this;
	var eContainer = eContainer;
	var oProvider = oProvider;
	var bFilled = false;
	var bExpanded = false;
	var eChildren = document.createElement( 'ul' );
	var eImage = document.createElement( 'img' );
	var oProviderItem = null;

	eContainer.appendChild( eChildren );

	/**
	 *  handles the return of the query to fill a node
	 * 
	 *  @param [oRequest] the request object
	 * 
	 */

	var fillHandler = function( oRequest ) {

		var xml = oRequest.responseXML;
		var eRoot = xml.documentElement;
		var items = oProvider.getItems( eRoot );

		for ( var i=0; i<items.length; i++ ) {
			var oItem = items[ i ];
			var oNode = new ExplorerNode(
				eChildren, oProvider.getItemProvider(oItem)
			);
			oNode.create( oItem, oProvider.isSelectable() );
		}
		
		bFilled = true;

	};

	/**
	 *  creates the node in the explorer, actually does the
	 *  drawing work and stuff.
	 * 
	 *  @param [oItem] the ProviderItem to draw
	 *  @param [bSelectable] is this node selectable?
	 * 
	 */

	this.create = function( oItem, bSelectable ) {

		// save item for later
		oProviderItem = oItem;

		var eLI = document.createElement( 'li' );

		// set up the toggle image if this node has children
		if ( oItem.hasChildren() ) {
			var eLink = document.createElement( 'a' );
			eImage.src = URL_BASE + '/images/12x12/expand.png';
			eLink.href = 'javascript:;';
			eLink.onclick = oSelf.toggle;
			eLink.appendChild( eImage );
			eLI.appendChild( eLink );
		}
		else {
			eImage.src = URL_BASE + '/images/12x12/empty.png';
			eLI.appendChild( eImage );
		}

		// set the link as selectable as appropriate
		if ( bSelectable ) {
			var eSelect = document.createElement( 'a' );
			eSelect.href = 'javascript:;';
			eSelect.onclick = function() {
				selectExplorerNode( oProviderItem );
			};
			eSelect.appendChild( document.createTextNode(oItem.getName()) );
			eLI.appendChild( eSelect );
		}
		else eLI.appendChild( document.createTextNode(oItem.getName()) );

		eLI.className = 'ExplorerTreeNode';
		eLI.appendChild( eChildren );
		eContainer.appendChild( eLI );

	};

	/**
	 *  toggles if this node is expanded or not.  if the node
	 *  has not yet been filled then this will also be done.
	 * 
	 */

	this.toggle = function() {
		if ( !bFilled )
			oSelf.fill();
		eChildren.style.display = bExpanded ? 'none' : 'block';
		eImage.src = URL_BASE + '/images/12x12/' + (bExpanded ? 'expand' : 'collapse') + '.png';
		bExpanded = !bExpanded;
	};

	/**
	 *  fills the node with it's children
	 * 
	 */

	this.fill = function() {
		if ( !bFilled )
			xmlQuery( URL_BASE + oProvider.getURL(), fillHandler );
	};

	/**
	 *  returns the ProviderItem that has been associated with
	 *  this node (if there is one)
	 * 
	 */

	this.getProviderItem = function() {
		return oProviderItem;
	};

}

/**
 *  takes a ProviderItem object to be the currently selected
 *  node for the tree.
 * 
 *  @param [oProviderItem] the item to be store as selected
 * 
 */

function selectExplorerNode( oProviderItem ) {
	var eDisplay = document.getElementById( 'ExplorerDisplay' );
	clearElement( eDisplay );
	eDisplay.appendChild( document.createTextNode('Selected: ' + 
		(oProviderItem ? oProviderItem.getName() : '(nothing)') ));
	currentProviderItem = oProviderItem;
}

/**
 *  handles the click of the OK button
 * 
 */

function okClicked() {
	if ( currentProviderItem == null ) {
		alert( 'You need to select something first!' );
	}
	else {
		opener.explorerSelectionHandler( currentProviderItem );
		self.close();
	}
}

/**
 *  handles the click of the NONE button
 * 
 */

function noneClicked() {
	opener.explorerSelectionHandler( null );
	self.close();
}

/**
 *  opens the main explorer using the specified provider
 * 
 *  @param [sProvider] string name of provider
 * 
 */

function openExplorer( oProvider ) {

	var oWindow = window.open(
		URL_BASE + '/explorer/',
		'ExplorerWindow',
		'width=600,height=400,toolbars=no'
	);
	oWindow.oInitialProvider = oProvider;
	oWindow.focus();

}
