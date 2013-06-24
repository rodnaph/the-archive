<?php

/**
 *  returns the html for a draggable element
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty smarty object
 *  @return html
 *
 */

function smutty_function_draggable( $params, $smarty ) {

	// make sure we have dependent plugins
	$smarty->depend( 'modifier', 'escape' );

	$elem = '';

	// normal parameters
	$id = $params['id'] ? $params['id'] : Smutty_Utils::getUniqueId();
	$text = $params['text'];
	$image = $params['image'] ? Smutty_Utils::getBaseUrl() . $params['image'] : '';
	$class = $params['class'];

	// create effects
	$createEffect = '';
	if ( $params['create_effect'] ) {
		$args = Smutty_Utils::strToHash( $params['create_effect'] );
		$createEffect = 'new Effect.' . ucfirst($args['name']) . '(\'' . $id . '\')';
	}

	// create the link!
	if ( $text )
		$elem = '<div id="' . $id . '" class="' . $class . '">' . smarty_modifier_escape($text) . '</div>';
	elseif ( $image )
		$elem = '<img id="' . $id . '" class="' . $class . '" src="' . $image . '" alt="" />';
	else
		Smutty_Error::fatal( 'you need to specify either some text or an image from drag_source', 'SmartyFunction_draggable' );

	return $elem . '<script type="text/javascript">' .
			'new Draggable(\'' . $id . '\',{revert:true});' .
			$createEffect .
		'</script>';

}

function smarty_function_draggable( $params, $smarty ) {
	echo smutty_function_draggable( $params, $smarty );
}

?>