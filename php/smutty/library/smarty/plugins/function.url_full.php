<?php

function smutty_function_url_full( $params, $smarty ) {

	return Smutty_Utils::getFullUrl( $params );

}

function smarty_function_url_full( $params, $smarty ) {
	echo smarty_function_url_full( $params, $smarty );
}

?>