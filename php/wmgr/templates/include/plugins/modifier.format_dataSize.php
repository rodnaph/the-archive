<?

/**
 *  this plugin is for formatting the body text of a wiki page
 *
 */

function smarty_modifier_format_dataSize( $bytes ) {

	// bytes
	if ( $bytes < 1024 )
		return "$bytes bytes";

	// kilobytes
	elseif ( $bytes < 10485764 )
		return round($bytes / 1024,2) . 'Kb';

	// megabytes
	return round($bytes / 10485764,2) . 'Mb';

}

?>
