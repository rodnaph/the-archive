<?php

function smutty_function_tabpage_end( $params, $smarty ) {

	return '</div>';

}

function smarty_function_tabpage_end( $params, $smarty ) {
	echo smutty_function_tabpage_end( $params, $smarty );
}

?>