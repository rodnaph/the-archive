<?php

/**
 *  returns the html for a droppable element
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty smarty object
 *  @return html
 *
 */

function smutty_function_droppable( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );

	$id = $params['id'] ? $params['id'] : Smutty_Utils::getUniqueId();

	// check elements should we accept
	$accept = $params['accept'];

	// work out what to do when an element is dropped
	// onto this element.  the default is to do nothing.
	$onDrop = 'smutty_doNothing';
	if ( $params['drop_url'] ) {
		// which element is gonna be getting the changes
		$update = $params['update'] ? $params['update'] : $id;
		// does the user want to provide feedback on the drop?
		$feedback = $params['feedback'];
		$onDrop = 'function ( eElem ) {' .
				'smutty_ajaxCall(' .
					'\'' . Smutty_Utils::getUrl(Smutty_Utils::strToHash($params['drop_url'])) . '\',' .
					'\'' . $update . '\',' .
					'null,' .
					'{ element_id: eElem.id },' .
					'\'' . $feedback . '\'' .
				');}';
	}
	elseif ( $params['drop_handler'] )
		$onDrop = $params['drop_handler'];

	// do we need to do any loading?
	$load = '';
	if ( $params['load_url'] )
		$load = 'smutty_ajaxCall(' .
					'\'' . Smutty_Utils::getUrl(Smutty_Utils::strToHash($params['load_url'])) . '\',' .
					'\'' . $update . '\'' .
				');';

	// create the link!
	return Smutty_Smarty::htmlElement( 'div',array(
		'id' => $id,
		'class' => $params['class']
	), $smarty ) . smarty_modifier_escape($params['text']) . '</div>' .
		'<script type="text/javascript">Droppables.add(\'' . $id . '\',' .
			'{' .
				'onDrop: ' . $onDrop . ',' .
				'accept: \'' . $accept . '\'' .
			'});' .
		$load . '</script>';

}

function smarty_function_droppable( $params, $smarty ) {
	echo smutty_function_droppable( $params, $smarty );
}

?>