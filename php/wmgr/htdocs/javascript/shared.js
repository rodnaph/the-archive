
/**
 *  this object represents a user
 *
 *  @param [id] the user id
 *  @param [name] the users name
 *
 */

function User( id, name ) {
	this.id = id;
	this.name = name;
}

/**
 *  represents a project
 *
 *  @param [id] the project id
 *  @param [name] the project name
 *
 */

function Project( id, name ) {
	this.id = id;
	this.name = name;
}

/**
 *  represents a page
 * 
 */

function Page( id, name ) {
	this.id = id;
	this.name = name;
}

/**
 *  this method takes the url of the resource to query, and a
 *  reference to a function to use as the handler when the
 *  response comes.
 *
 *  @param [sURL] the resource URL
 *  @param [rHandler] function reference to handler
 *  @param [oObject] optional user defined object
 *
 */

function xmlQuery( sURL, rHandler, oObject ) {

	var oRequest;
	var rClosure = function() {
		if ( oRequest != null )
			if ( oRequest.readyState == 4 && oRequest.status == 200 )
				rHandler( oRequest, oObject );
	};

	if ( window.XMLHttpRequest ) {
		oRequest = new XMLHttpRequest();
		oRequest.onreadystatechange = rClosure;
		oRequest.open( 'GET', sURL, true );
		oRequest.send( null );
	}

	else if ( window.ActiveXObject ) {
		oRequest = new ActiveXObject( 'Microsoft.XMLHTTP' );
		if ( oRequest ) {
			oRequest.onreadystatechange = rClosure;
			oRequest.open( 'GET', sURL, true );
			oRequest.send();
        	}
   	}

}

/**
 *  returns the text value of a child node
 *
 *  @param [xmlNode] the parent node to search
 *  @param [childNodeName] the name of the child node to find
 *
 */

function getChildValue( xmlNode, childNodeName ) {

	var children = xmlNode.childNodes;
	
	for ( var i=0; i<children.length; i++ ) {
		var child = children[ i ];	
		if ( child.nodeName == childNodeName )
			if ( child.firstChild != null )
				return child.firstChild.nodeValue;
	}
	
	return null;

}

/**
 *  returns a child node of the current node with the
 *  specified name.
 *
 *  @param [xmlNode] the parent node to search
 *  @param [childNodeName] the name of the child node to find
 *
 */

function getChild( xmlNode, childNodeName ) {

	var children = xmlNode.childNodes;
	
	for ( var i=0; i<children.length; i++ ) {
		var child = children[ i ];
		if ( child.nodeName == childNodeName )
			return child;
	}
	
	return null;

}

/**
 *  clears a DOM element of all its children
 *
 *  @param [eElem] the element to clear
 *
 */

function clearElement( eElem ) {

	while ( eElem.firstChild != null )
		eElem.removeChild( eElem.firstChild );

}

/**
 *  returns the X position of a page element
 *
 *  @param [obj] the object to find x position of
 *
 */

function getXPos( obj ) {
	var curleft = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curleft += obj.offsetLeft
			obj = obj.offsetParent;
		}
	}
	else if (obj.x)
		curleft += obj.x;
	return curleft;
}

/**
 *  returns the Y position of a page element
 *
 *  @param [obj] the object to find Y position of
 *
 */

function getYPos( obj ) {
	var curtop = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curtop += obj.offsetTop
			obj = obj.offsetParent;
		}
	}
	else if (obj.y)
		curtop += obj.y;
	return curtop;
}
