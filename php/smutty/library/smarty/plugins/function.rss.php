<?php

/**
 *  returns the html to create a link to an
 *  automatcically generated smutty rss feed.
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty the smarty object
 *  @return nothing
 *
 */

function smutty_function_rss( $params, $smarty ) {

	$plural = ucfirst(Smutty_Inflector::pluralize( $params['model'] ));

	return Smutty_Smarty::htmlElement( 'link', array(
		'rel' => 'alternate',
		'title' => "$plural RSS",
		'href' => Smutty_Utils::getUrl(array(
			'controller' => 'smutty',
			'action' => 'rss',
			'model' => $params['model']
		)),
		'type' => 'application/rss+xml'
	), $smarty );

}


function smarty_function_rss( $params, $smarty ) {
	echo smutty_function_rss( $params, $smarty );
}

?>