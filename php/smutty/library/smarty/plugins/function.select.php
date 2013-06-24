<?php

/**
 *  returns the html for a select option
 *
 *  @param Object $obj the object to draw
 *  @param String $text the name of the objects text property
 *  @param String $value the name of the objects value property
 *  @param String $selected a value to select
 *  @return the element html
 *
 */

function smutty_function_select_option( $obj, $text, $value, $selected ) {

	return '<option value="' . $obj->$value . '"' .
			( $obj->$value == $selected ? ' selected="selected"' : '' ) .
			'>' .
			smarty_modifier_escape($obj->$text) .
		'</option>';

}

/**
 *  returns the html for a html select option
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty the smarty template
 *  @return the html
 *
 */

function smutty_function_select( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );
	$smarty->depend( 'function', 'label' );

	$select = '';
	$from = $params['from'];
	$text = $params['text'] ? $params['text'] : '';
	$value = $params['value'] ? $params['value'] : 'id';
	$selected = $params['selected'] ? $params['selected'] : false;
	$group = $params['group'];

	// add a label?
	if ( $label = $params['label'] ) {
		$select .= smutty_function_label(array(
			'for' => $params['name'],
			'text' => $label,
			'class' => $params['labelClass'],
			'id' => $params['labelId']
		), $smarty );
	}

	$select .= Smutty_Smarty::htmlElement( 'select', array(
		'name' => Smutty_Smarty::getFieldName($params['name']),
		'class' => $params['class'],
		'id' => $params['id']
	), $smarty );
	$select .= '<option value=""></option>';

	if ( $from )
		foreach ( $from as $obj ) {
			// do we need to try and fine a text attribute?
			if ( !$text ) {
				$options = array( 'name', 'title', 'subject', 'id' );
				foreach ( $options as $option )
					if ( $obj->$option ) {
						$text = $option;
						break;
					}
			}
			// draw option groups?
			if ( $group ) {
				$select .= '<optgroup label="' . $obj->$text . '">';
				$obj2s = $obj->$group;
				foreach ( $obj2s as $obj2 )
					$select .= smutty_function_select_option( $obj2, $text, $value, $selected );
				$select .= '</optgroup>';
			}
			else $select .= smutty_function_select_option( $obj, $text, $value, $selected );
		}

	$select .= '</select>';

	return $select;

}

function smarty_function_select( $params, $smarty ) {
	echo smutty_function_select( $params, $smarty );
}

?>