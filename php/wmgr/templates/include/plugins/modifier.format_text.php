<?

/**
 *  this plugin is for formatting the body text of a wiki page
 *
 */

function smarty_modifier_format_text( $text ) {

	$text = nl2br( $text );

	return $text;

}

?>
