
/**
 *  checks the required fields are present, returns true
 *  if they are, false if they're not
 *
 *  @param [form] the form to check
 *  @param [arguments] the field names to check
 *
 */

function checkForm( form ) {

	for ( var i=1; i<arguments.length; i++ ) {
		if ( form[arguments[i]].value == '' ) {
			alert( ':: burp\n\nSorry, but you have missed a field.' );
			return false;
		}
	}

	// all fields checked, must be ok
	return true;

}
