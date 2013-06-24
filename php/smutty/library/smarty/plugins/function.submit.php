<?php

/**
 *  returns the html for a form submit button
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_submit( $params, $smarty ) {

	return Smutty_Smarty::htmlElement( 'input', array(
		'type' => 'submit',
		'value' => $params['text'],
		'id' => $params['id'],
		'class' => $params['class']
	), $smarty );

}


function smarty_function_submit( $params, $smarty ) {
	echo smutty_function_submit( $params, $smarty );
}

?>