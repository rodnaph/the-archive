<?php

/**
 *  returns the html for a form input field
 *
 *  @param array $params parameters
 *  @param Smarty $smarty smarty object
 *  @return the element html
 *
 */

function smutty_function_field( $params, $smarty ) {

	$smarty->depend( 'function', 'label' );

	$field = '';

	// add a label?
	if ( $label = v($params,'label') ) {
		$smarty->depend( 'function', 'label' );
		$field .= smutty_function_label(array(
			'for' => v( $params, 'name' ),
			'text' => $label,
			'class' => v( $params, 'labelClass' ),
			'id' => v( $params, 'labelId' )
		), $smarty );
	}

	// is it a "live" field?
	$liveField = '';
	if ( v($params,'url') && v($params,'update') )
		$liveField = 'smutty_ajaxLiveFieldChange(' .
			'\'' . Smutty_Utils::getUrl(Smutty_Utils::strToHash($params['url'])) . '\',' .
			'\'' . $params['update'] . '\',' .
			'this,' .
			'\'' . $params['feedback'] . '\'' .
		');';

	return $field . Smutty_Smarty::htmlElement( 'input', array(
		'name' => Smutty_Smarty::getFieldName(v($params,'name')),
		'type' => w($params,'type','text'),
		'class' => v($params,'class'),
		'maxlength' => v($params,'maxlength'),
		'value' => v($params,'value'),
		'onkeyup' => $liveField,
		'id' => v($params,'id'),
		'checked' => v($params,'checked')
	), $smarty );

}


function smarty_function_field( $params, $smarty ) {
	echo smutty_function_field( $params, $smarty );
}

?>