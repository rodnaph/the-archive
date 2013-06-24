<?php

define( 'XML_HTMLSAX3', 'library/safehtml/' );
include_once XML_HTMLSAX3 . 'safehtml.php';

/**
 *  this plugin is for formatting some text
 *
 */

function smarty_modifier_safehtml( $text ) {

	$safe = new safehtml();

	$text = preg_replace( '/\r\n/', "\n", $text );
	$text = preg_replace( '/\n\n/', '<br /><br />', $text );

	// add alt attributes to images
	$text = preg_replace( '/<img /', '<img alt="Image" ', $text );

	$text = $safe->parse( $text );

	return $text;

}

?>
