<?php

/**
	*  returns the html for a hidden form field
	*
	*  @param array $params parameters
	*  @param Smarty $smarty smarty object
	*  @return the element html
	*
	*/

function smutty_function_hidden( $params, $smarty ) {

	return Smutty_Smarty::htmlElement( 'input', array(
		'type' => 'hidden',
		'name' => Smutty_Smarty::getFieldName(v($params,'name')),
		'value' => v( $params, 'value' ),
		'id' => v( $params, 'id' )
	), $smarty );

}

function smarty_function_hidden( $params, $smarty ) {
	echo smutty_function_hidden( $params, $smarty );
}

?>