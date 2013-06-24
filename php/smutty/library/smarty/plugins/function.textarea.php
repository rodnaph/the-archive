<?php

/**
 *  returns the html for a form textarea
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_textarea( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );
	$smarty->depend( 'function', 'label' );

	$textarea = '';

	// add a label?
	if ( $label = $params['label'] ) {
		$smarty->depend( 'function', 'label' );
		$textarea .= smutty_function_label(array(
			'for' => $params['name'],
			'text' => $label,
			'class' => $params['labelClass'],
			'id' => $params['labelId']
		), $smarty );
	}

	return $textarea . Smutty_Smarty::htmlElement( 'textarea', array(
		'name' => Smutty_Smarty::getFieldName($params['name']),
		'class' => $params['class'],
		'id' => $params['id']
	), $smarty ) .
	smarty_modifier_escape( $params['value'] ) .
	'</textarea>';

}


function smarty_function_textarea( $params, $smarty ) {
	echo smutty_function_textarea( $params, $smarty );
}

?>