<?php

/**
 *  returns the html for a form label
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_label( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );

	return Smutty_Smarty::htmlElement( 'label', array(
		'for' => Smutty_Smarty::getFieldName($params['for']),
		'class' => $params['class'],
		'id' => $params['id']
	), $smarty ) .
	smarty_modifier_escape( $params['text'] ) .
	'</label>';

}


function smarty_function_label( $params, $smarty ) {
	echo smutty_function_label( $params, $smarty );
}

?>