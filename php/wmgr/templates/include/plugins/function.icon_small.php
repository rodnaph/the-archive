<?

/**
 *  this plugin is for drawing a small (12x12) icon
 *
 */

function smarty_function_icon_small( $params ) {
	$icon = $params['icon'];
	$file = $params['file'];
	if ( $icon ) {
?>
	<img src="<?= URL_BASE ?>/images/12x12/<?= $icon->filename ?>"
		alt="<?= smarty_modifier_escape($icon->name) ?>"
		title="<?= smarty_modifier_escape($icon->name) ?>" />
<?
	}
	elseif ( $file ) {
?>
	<img src="<?= URL_BASE ?>/images/12x12/<?= $file ?>" />
<?
	}
}

?>
