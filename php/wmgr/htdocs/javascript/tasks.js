
/**
 *  shows the task update form
 *
 */

function showUpdateTaskWrap() {

	document.getElementById('TaskUpdateWrap').style.display='block';
	self.location.href = '#UpdateTaskWrap';

}

/**
 *  adds another field for uploading an attachment
 *
 */

function addAttachmentField() {

	var eDiv = document.getElementById( 'TaskUpdateDocs' );
	var eLabel = document.createElement( 'label' );
	var eInput = document.createElement( 'input' );

	eInput.type = 'file';
	eInput.name = 'doc[]';
	eLabel.appendChild( document.createTextNode(' ') );
	eDiv.appendChild( eLabel );
	eDiv.appendChild( eInput );

}
