<?php

function smutty_function_form_end( $params, $smarty ) {

	return '</form>';

}

function smarty_function_form_end( $params, $smarty ) {
	echo smutty_function_form_end( $params, $smarty );
}
?>