<?php

/**
 *  returns the html for a set of date field selects
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty smarty object
 *  @return html
 *
 */

function smutty_function_datefields( $params, $smarty ) {

	$smarty->depend( 'function', 'select' );

	$html = '';
	$value = $params['value'];

	if ( $label = $params['label'] ) {
		$smarty->depend( 'function', 'label' );
		$html .= smutty_function_label(array(
			'for' => $params['name'],
			'text' => $label,
			'class' => $params['labelClass'],
			'id' => $params['labelId']
		), $smarty );
	}

	// work out date values if we have
	// something to work with.
	$year = null;
	$month = null;
	$day = null;
	if ( $value ) {
		$ts = date( 'U', strtotime($value) );
		$year = date( 'Y', $ts );
		$month = date( 'm', $ts );
		$day = date( 'd', $ts );
	}

	// year
	$html .= smutty_function_select(array(
		id => ( $params['id'] ? $params['id'] . '_year' : '' ),
		name => $params['name'] . '_year',
		from => smutty_function_datefields_getObjectRange(2000,2010),
		selected => $year,
		'class' => $params['class']
	), $smarty );

	// month
	$html .= smutty_function_select(array(
		id => $params['id'] ? $params['id'] . '_month' : '',
		name => $params['name'] . '_month',
		from => smutty_function_datefields_getObjectRange(1,12),
		selected => $month,
		'class' => $params['class']
	), $smarty );

	// day
	$html .= smutty_function_select(array(
		id => ( $params['id'] ? $params['id'] . '_day' : '' ),
		name => $params['name'] . '_day',
		from => smutty_function_datefields_getObjectRange(1,31),
		selected => $day,
		'class' => $params['class']
	), $smarty );

	return $html;

}

/**
 *  returns an array of objects with they're id and name
 *  attributes set to the specified range of numbers
 *
 *  @param int $min minimum
 *  @param int $max maximum
 *  @return array
 *
 */

function smutty_function_datefields_getObjectRange( $min, $max ) {

	$values = array();

	for ( $i=$min; $i<=$max; $i++ ) {
		$value = new stdclass();
		$value->id = $i;
		$value->name = $i;
		$values[] = $value;
	}

	return $values;

}

function smarty_function_datefields( $params, $smarty ) {
	echo smutty_function_datefields( $params, $smarty );
}

?>