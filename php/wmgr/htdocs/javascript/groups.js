
/**
 *  updates a groups tags information
 *
 */

function updateGroupTags( groupID ) {

	var eTags = document.getElementById( 'GroupTags' );
	var url = URL_BASE + '/xml/groups/updateTags.xml.php?id=' + groupID + '&tags=';
	var sTags = new String( eTags.value );
	var aTags = sTags.split(/ /);
	var eButton = document.getElementById( 'GroupUpdateTags' );

	eButton.value = 'Saving...';

	for ( var i=0; i<aTags.length; i++ )
		url = url + escape( ',' + aTags[i] );

	xmlQuery( url, updateGroupTagsHandler );

}

/**
 *  handles the return of the query to update the groups
 *  tags.
 *
 *  @param [oRequest] the request object
 *
 */

function updateGroupTagsHandler( oRequest ) {

	var eTags = document.getElementById( 'GroupTags' );
	var xml = oRequest.responseXML;
	var eGroup = xml.documentElement;
	var aTags = eGroup.getElementsByTagName( 'tag' );

	eTags.value = '';

	for ( var i=0; i<aTags.length; i++ )
		eTags.value += aTags[i].firstChild.nodeValue + ' ';

	updateTagsButton( false );

}

/**
 *  updates the 'update tags' button
 *
 *  @param [bShow] boolean indicating if the button should
 *  be shown or not.
 *
 */

function updateTagsButton( bShow ) {

	var eButton = document.getElementById( 'GroupUpdateTags' );

	eButton.style.visibility = bShow ? 'visible' : 'hidden';
	eButton.value = 'Update';

}

/**
 *  approves a user to join a group after confirming the
 *  action with the user.
 *
 *  @param [groupID] the group id to join
 *  @param [userID] the user id to join the group
 *
 */

function approveJoinGroup( groupID, userID ) {

	if ( confirm('Are you sure you want to allow this user access to this group?') )
		self.location.href = 'joinApprove.php?group_id=' + groupID + '&user_id=' + userID;

}
