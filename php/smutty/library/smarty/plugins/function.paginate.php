<?php

/**
 *  returns the html for drawing page links
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty smarty object
 *  @return html
 *
 */

function smutty_function_paginate( $params, $smarty ) {

	$smarty->depend( 'function', 'link' );

	$url = array();
	if ( isset($params['url']) )
		$url = is_array($params['url']) ? $params['url'] : Smutty_Utils::strToHash($params['url']);

	$total = $params['total'];
	$perPage = $params['perPage'];
	$startParam = $params['startParam'] ? $params['startParam'] : 'start';
	$start = $params['start'];
	$html = w( $params, 'text', '' ) . ' ';

	// query string args
	$smutty = $smarty->get_template_vars( 'smutty' );
	$args = array();
	if ( $smutty->get )
		foreach ( $smutty->get as $key => $value )
			$args[$key] = $value;

	$pages = 10;
	$first = round(( $start - ($perPage*($pages/2)) ) / $perPage) + 1; // first link to show
	if ( $first < 1 ) $first = 1;
	$max = round( $total / $perPage );
	if ( $max > $pages ) $max = $pages;
	$curr = round( $start / $perPage ) + 1;
	$last = round( $total / $perPage );

	if ( $first > 1 ) {
		$html .= smutty_function_link(array(
			'url' => $url,
			'args' => $args,
			'text' => '1'
		), $smarty );
		$html .= ( $first > 2 ) ? ' ... ' : ' ';
	}

	if ( $first + $max > $last )
		$first = $last - $max + 1;

	for ( $page=$first; ($page<($first+$max)) && ($page<=$last); $page++ ) {
		$pageUrl = $url;
		$pageUrl[ $startParam ] = ($page - 1) * $perPage;
		$html .= smutty_function_link(array(
			'url' => $pageUrl,
			'args' => $args,
			'text' => $page,
			'class' => $page == $curr ? 'current' : ''
		), $smarty );
		$html .= ' ';
	}

	if ( $first+$pages <= $total/$perPage ) {
		$lastUrl = $url;
		$lastUrl[ $startParam ] = $total - $perPage;
		$html .= ( $last > $first+$pages ) ? ' ... ' : ' ';
		$html .= smutty_function_link(array(
			'url' => $lastUrl,
			'args' => $args,
			'text' => $last
		), $smarty );
	}

	return $html;

}

function smarty_function_paginate( $params, $smarty ) {
	echo smutty_function_paginate( $params, $smarty );
}

?>
