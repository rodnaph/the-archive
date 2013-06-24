<?php

function smutty_function_smutty_link( $params, $smarty ) {

	$url = Smutty_Utils::getUrl(array(
		'controller' => 'smutty',
		'action' => 'resource',
		'folder' => 'images',
		'file' => 'smutty-logo.png'
	));

	return '<a href="http://smutty.pu-gh.com" title="Smutty Powered"><img ' .
		'style="border:none;" ' .
		'src="' . $url . '" alt="Smutty Logo" /></a>';

}

function smarty_function_smutty_link( $params, $smarty ) {
	echo smutty_function_smutty_link( $params, $smarty );
}

?>