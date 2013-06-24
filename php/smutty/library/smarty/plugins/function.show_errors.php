<?php

function smutty_function_show_errors( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );
	$errors = $smarty->get_template_vars( 'errors' );
	$text = $params['text'] ? $params['text'] : 'Error Saving!';

	if ( $errors ) {
		$html = '<h2 class="error">' . smarty_modifier_escape($text) . '</h2><ul>';
		foreach ( $errors as $error )
			$html .= '<li>' . smarty_modifier_escape($error) . '</li>';
		return $html .= '</ul>';
	}

}

function smarty_function_show_errors( $params, $smarty ) {
	echo smutty_function_show_errors( $params, $smarty );
}

?>
