<?

function smarty_modifier_wikitext_link( $text ) {
	$text = $text[1];
	preg_match( '/^(\w+)(.*)/', $text, $matches );
	$name = trim( $matches[1] );
	$text = $matches[2] ? $matches[2] : $name;
	$url = Smutty_Utils::getUrl(array(
		controller => 'wiki',
		action => 'index',
		name => $name
	));
	return '<a href="' . $url . '">' . $text . '</a>';
}

function smarty_modifier_wikitext( $text ) {

	$text = preg_replace( '/<\?/', '&lt;?', $text );
	$text = preg_replace( '/\?>/', '?&gt;', $text );

	$lines = preg_split( '/\n/', $text );
	$text = '';
	foreach ( $lines as $line ) {
		$text .= $line;
	}

	$text = preg_replace_callback(
		'/\[(.*?)\]/',
		'smarty_modifier_wikitext_link',
		$text
	);

	return $text;

}

?>