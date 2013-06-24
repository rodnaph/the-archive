<?php

function smutty_function_url( $params ) {

	return Smutty_Utils::getUrl( $params );

}

function smarty_function_url( $params ) {
	echo smutty_function_url( $params );
}

?>