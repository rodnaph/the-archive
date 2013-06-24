<?php

function smutty_function_ajax_libs( $params, $smarty ) {

	static $done;

	if ( $done == null ) {

		$prototype = Smutty_Utils::getUrl(array(
			'controller' => 'smutty',
			'action' => 'resource',
			'folder' => 'scriptaculous',
			'file' => 'prototype.js'
		));
		$scriptaculous = Smutty_Utils::getUrl(array(
			'controller' => 'smutty',
			'action' => 'resource',
			'folder' => 'scriptaculous',
			'file' => 'scriptaculous.js'
		));
		$ajax = Smutty_Utils::getUrl(array(
			'controller' => 'smutty',
			'action' => 'resource',
			'folder' => 'javascript',
			'file' => 'ajax.js'
		));
		$dhtml = Smutty_Utils::getUrl(array(
			'controller' => 'smutty',
			'action' => 'resource',
			'folder' => 'javascript',
			'file' => 'dhtml.js'
		));

		// libs included
		$done = true;

		return "
<script type=\"text/javascript\" src=\"$prototype\"></script>
<script type=\"text/javascript\" src=\"$scriptaculous\"></script>
<script type=\"text/javascript\" src=\"$ajax\"></script>
<script type=\"text/javascript\" src=\"$dhtml\"></script>
<script type=\"text/javascript\">
var BASE_URL = '" . Smutty_Utils::getBaseUrl() . "';
</script>
	";

	}

}

function smarty_function_ajax_libs( $params, $smarty ) {
	echo smutty_function_ajax_libs( $params, $smarty );
}

?>