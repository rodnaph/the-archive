<?php

function smarty_prefilter_allow_assoc_attrs_replace( $varString ) {

	$matches = preg_split( '/(\w+\s*=\s*)/', $varString[1], -1, PREG_SPLIT_DELIM_CAPTURE );
	$pairs = array();
	for ( $i=1; $i<sizeof($matches); $i+=2 )
		array_push( $pairs, $matches[$i] . $matches[$i+1] );
	$attrs = '';

	foreach ( $pairs as $pair ) {

		$info = explode( '=', $pair );
		$name = trim( $info[0] );
		$value = trim( $info[1] );

		if ( substr($value,0,1) == '$' )
			$value = "`$value`";
		else
			$value = preg_replace( '/^"(.*)"$/', '$1', $value );

		$attrs .= ",$name,$value";

	}

	$attrs = substr( $attrs, 1 );

	return "=\"$attrs\"";

}

/**
 *  this filter changes all assoc array style attributes to
 *  flat strings that can then be changed back by whichever
 *  plugin needs to use them.
 *
 */

function smarty_prefilter_allow_assoc_attrs( $tpl_source, &$smarty ) {

	return preg_replace_callback(
		'/=\{ (.*?)\}/s',
		'smarty_prefilter_allow_assoc_attrs_replace',
		$tpl_source
	);

}

?>