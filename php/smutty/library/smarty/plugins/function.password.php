<?php

/**
 *  returns the html for a form password field
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_password( $params, $smarty ) {

	$smarty->depend( 'function', 'field' );

	$params['type'] = 'password';

	return smutty_function_field( $params, $smarty );

}

function smarty_function_password( $params, $smarty ) {
	echo smutty_function_password( $params, $smarty );
}

?>