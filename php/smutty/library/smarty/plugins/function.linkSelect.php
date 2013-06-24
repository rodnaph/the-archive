<?php

function smutty_function_linkSelectText( $params = null ) {

	static $data;

	if ( $params != null )
		$data = array(
			'text' => v( $params, 'text' ),
			'id' => w( $params, 'id', 'current' ),
			'class' => v( $params, 'class' )
		);

	return $data;

}

function smutty_function_linkSelect( $params, $smarty ) {
	smutty_function_linkSelectText( $params );
}

function smarty_function_linkSelect( $params, $smarty ) {

	smutty_function_linkSelect( $params, $smarty );
}

?>