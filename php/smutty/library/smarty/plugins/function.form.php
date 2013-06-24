<?php

/**
 *  returns the html for a form
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty smarty object
 *  @return html
 *
 */

function smutty_function_form( $params, $smarty ) {

	// fetch the url for the request
	$url = Smutty_Utils::getUrl(
		Smutty_Utils::strToHash($params['url'])
	);

	// work out the handler
	$update = v($params,'update');
	$handler = v($params,'handler');
	$feedback = v($params,'feedback');
	$method = w($params,'method','post');
	$id = v($params,'id');
	$form = '';

	// if the form is to be GPG signed then we need
	// to include a special hidden field
	if ( v($params,'gpgSigned') )
		$url .= ENIGFORM_SIG;

	// normal form or ajax form?
	if ( $update )
		$form = '<form onsubmit="smutty_ajaxForm(this,' .
				'\'' . $url . '\',' .
				'\'' . $update . '\',' .
				'\'' . $handler . '\',' .
				'null,' .
				'\'' . $feedback . '\'' .
			');return false;" ' .
			Smutty_Smarty::buildAttrString(array(
				'id' => v($params,'id'),
				'class' => v($params,'class')
			), $smarty ) . '>';
	else
		$form = Smutty_Smarty::htmlElement( 'form', array(
			'method' => $method,
			'action' => $url,
			'id' => v($params,'id'),
			'class' => v($params,'class')
		), $smarty );

	return $form;

}

function smarty_function_form( $params, $smarty ) {
	echo smutty_function_form( $params, $smarty );
}

?>