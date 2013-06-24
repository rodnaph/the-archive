<?php

function smutty_function_javascript( $params, $smarty ) {

	return Smutty_Smarty::htmlElement( 'script', array(
		'type' => 'text/javascript',
		'src' => Smutty_Utils::getBaseUrl() . '/javascript/' . v($params,'file')
	), $smarty ) . '</script>';

}

function smarty_function_javascript( $params, $smarty ) {
	echo smutty_function_javascript( $params, $smarty );
}

?>