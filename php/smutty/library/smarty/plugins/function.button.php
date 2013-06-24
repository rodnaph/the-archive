<?php

/**
	*  returns the html for a button
	*
	*  @param array $params parameters
	*  @param Smarty $smarty smarty object
	*  @return the element html
	*
	*/

function smutty_function_button( $params, $smarty ) {

	$urlHash = Smutty_Utils::strToHash( $params['url'] );
	$url = Smutty_Utils::getUrl( $urlHash );
	$update = v( $params, 'update' );
	$handler = v( $params, 'handler' );

	return Smutty_Smarty::htmlElement( 'input', array(
		'type' => 'button',
		'value' => v( $params, 'text' ),
		'onclick' => 'javascript:smutty_ajaxForm(' .
				'this.form,' .
				'\'' . $url . '\',' .
				'\'' . $update . '\',' .
				'\'' . $handler . '\'' .
			');',
		'class' => v( $params, 'class' ),
		'id' => v( $params, 'id' )
	), $smarty );

}

function smarty_function_button( $params, $smarty ) {
	echo smutty_function_button( $params, $smarty );
}

?>