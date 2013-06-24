<?

function smarty_modifier_linkcode_replace( $str ) {

	$tpl = new Smutty_Template();
	$tpl->depend( 'function', 'link' );

	return smutty_function_link(array(
		'url' => array(
			'action' => 'viewClass',
			'name' => $str[0]
		),
		'text' => $str[0]
	), $tpl );

}

function smarty_modifier_linkcode( $line ) {

	$tpl = new Smutty_Template();
	$tpl->depend( 'modifier', 'escape' );

	$line = smarty_modifier_escape( $line );

	// links to other classes
	$line = preg_replace_callback( '/(Smutty_[A-Za-z_]*)/', 'smarty_modifier_linkcode_replace', $line );

	// anchors to functions
	$line = preg_replace( '/function (\w+)\(/', '<a name="$1"></a>function $1(', $line );

	return $line;

}

?>