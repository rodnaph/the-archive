<?php

/**
 *  returns the html for displaying a brief notice on the page
 *
 *  @param array $params the parameters
 *  @param Smarty $smarty the smarty object
 *  @return html
 *
 */

function smutty_function_notice( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );

	$type = w( $params,'type','div' );
	$text = v( $params, 'text' );
	$id = w( $params, 'id', 'NOTICE' . rand() );
	$delay = w( $params, 'delay', 5000 );
	$html = '';

	$html = Smutty_Smarty::htmlElement( $type, array(
		'class' => v( $params, 'class' ),
		'id' => $id
	), $smarty );

	$html .= smarty_modifier_escape($text) . "</$type>" .
		'<script type="text/javascript">' .
		'setTimeout(\'document.getElementById(\\\'' . $id . '\\\').style.display=\\\'none\\\'\',' . $delay . ');' .
		'</script>';

	return $html;

}

function smarty_function_notice( $params, $smarty ) {
	echo smutty_function_notice( $params, $smarty );
}

?>