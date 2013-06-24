
var smuttyLiveFieldTimeouts = new Array();

/**
 *  handles calls from ajax_link's
 *
 *  @param sUrl url of resource
 *  @param sUpdate id of element to update
 *  @param sHandler optional name of handler function
 *  @return nothing
 *
 */

function smutty_ajaxLink( sUrl, sUpdate, sHandler ) {
	smutty_ajaxCall( sUrl, sUpdate, sHandler, null );
}

/**
 *  handles calls from ajax_form's
 *
 *  @param oForm the form to submit
 *  @param sUrl the url of the resource
 *  @param sUpdate id of element to update
 *  @param sHandler optional custom handler function
 *  @param sParameters request params
 *  @param sFeedback id of feedback element
 *  @return nothing
 *
 */

function smutty_ajaxForm( oForm, sUrl, sUpdate, sHandler, sParameters, sFeedback ) {
	Element.extend( oForm );
	smutty_ajaxCall( sUrl, sUpdate, sHandler, oForm.serialize(), sFeedback );
}

/**
 *  makes an ajax call.
 *
 *  @param sUrl the url resource
 *  @param sUpdate the element id to receive the response
 *  @param sHandler optional function to handle the response
 *  @param sParameters any params for the request
 *  @param sFeedback optional id of element for feedback
 *  @return nothing
 *
 */

function smutty_ajaxCall( sUrl, sUpdate, sHandler, sParameters, sFeedback ) {

	// get a reference to the handler function
	var rHandler = null;
	if ( !sHandler )
		sHandler = 'smutty_ajaxUpdate';
	eval( 'rHandler = ' + sHandler + ';' );

	new Ajax.Request(
		sUrl,
		{
			parameters: sParameters,
			onLoading: function() {
				if ( sFeedback )
					smutty_ajaxFeedback( sFeedback, 'Updating...' );
			},
			onComplete: function( oRequest ) {
				if ( sFeedback )
					smutty_ajaxFeedback( sFeedback, '' );
				rHandler( oRequest, sUpdate );
			},
			onFailure: function( oRequest ) {
				alert( 'Ajax error!' );
			}
		}
	);

}

/**
 *  sets a feedback element with some content.  if you want
 *  to clear the feedback then just pass the empty string.
 *
 *  @param sId id of element
 *  @param sContent the contect to set
 *  @return nothing
 *
 */

function smutty_ajaxFeedback( sId, sContent ) {
	var eElem = $( sId );
	if ( eElem != null )
		eElem.innerHTML = sContent ? '<img src="' + BASE_URL + '/smutty/resource/images/updating.gif" ' +
			' alt="Updating" /> ' + sContent : '';
}

/**
 *  this is the default handles for ajax queries and just
 *  updates the element id specified by sUpdate with the
 *  response of the query
 *
 *  @param oRequest the request object
 *  @param sUpdate id of element to update
 *  @return nothing
 *
 */

function smutty_ajaxUpdate( oRequest, sUpdate ) {

	var eElem = $( sUpdate )

	if ( eElem ) {

		var sResult = new String( oRequest.responseText );

		eElem.innerHTML = sResult;
		sResult.evalScripts();

	}

	else alert( 'AjaxError: element "' +sUpdate+ '" does not exist...' );

}

/**
 *  a function that just does nothing.  used as a function when
 *  no action is required (but we can still pass a valid function
 *  to whatever wants it.
 *
 *  @return nothing
 *
 */

function smutty_doNothing() {
	return true;
}

/**
 *  called when a live field changes
 *
 *  @param sUrl the url to call on change
 *  @param sUpdate the element to update
 *  @param oField the field to watch
 *  @param sFeedback id of feedback element
 *  @return nothing
 *
 */

function smutty_ajaxLiveFieldChange( sUrl, sUpdate, oField, sFeedback ) {
	// clear any timeouts
	if ( timeout = smuttyLiveFieldTimeouts[oField.id] )
		clearTimeout( timeout );
	// set a timeout
	smuttyLiveFieldTimeouts[oField.id] = setTimeout( function() {
		smutty_ajaxCall( sUrl + '/' + escape(oField.value), sUpdate, null, null, sFeedback );
	}, 1000 );
}
