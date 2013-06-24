<?php

/**
 *  returns the html for a form checkbox field
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_checkbox( $params, $smarty ) {

	$smarty->depend( 'function', 'field' );

	$params['type'] = 'checkbox';
	$params['checked'] = v($params,'value') ? 'checked' : '';

	return smutty_function_field( $params, $smarty );

}

function smarty_function_checkbox( $params, $smarty ) {
	echo smutty_function_checkbox( $params, $smarty );
}

?>