<?

/**
 *  this plugin is for formatting the body text of a wiki page
 *
 */

function smarty_function_html_option( $params ) {
	$iconStyle = '';
	if ( $params['icon'] ) {
		$iconStyle = " style=\"background-image:url(" . URL_BASE . "/images/12x12/" . $params['icon']->filename . ");" .
			"background-repeat:no-repeat;background-position:right;\"";
	}
?>
	<option<? if ( $params['id'] == $params['select'] ) { ?> selected="selected"<? } ?> value="<?= $params['id'] ?>" <?= $iconStyle ?>><?= smarty_modifier_escape($params['name']) ?></option>
<?
}

?>
