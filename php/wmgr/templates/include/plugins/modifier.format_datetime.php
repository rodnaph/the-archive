<?

/**
 *  this plugin is for formatting a timestamp to a datetime
 *
 */

function smarty_modifier_format_datetime( $ts ) {

	return date( 'H:i \o\n jS F, Y', $ts );

}

?>
