<?php /* Smarty version 2.6.16, created on 2007-06-09 08:08:25
         compiled from syndication/rss-2.0.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'pluralize', 'syndication/rss-2.0.tpl', 56, false),array('function', 'url_full', 'syndication/rss-2.0.tpl', 57, false),)), $this); ?>
<?php 

header( 'Content-type: text/xml' );

function getRSSItemValue( $item, $options ) {
	foreach ( $options as $option )
		if ( $option && ($value = $item->$option) )
			return smarty_modifier_escape( substr( $value, 0, 200 ) );
}

function renderRSSItem( $smarty, $item ) {

		$smarty->depend( 'modifier', 'escape' );
		$smarty->depend( 'function', 'url_full' );

		// work out item values
		$model = $smarty->get_template_vars( 'model' );
		$title = getRSSItemValue( $item, array( $model->rss['title'], 'title', 'subject', 'name' ) );
		$desc = getRSSItemValue( $item, array( $model->rss['description'], 'description', 'body' ) );
		$id = getRSSItemValue( $item, array( $model->rss['id'], 'id', 'name' ) );

		// now we're gonna need an url
		$url = 'NOTHING';
		if ( $data = $model->rss['url'] ) {
			$params = array();
			foreach ( $data as $key => $value )
				switch ( $key ) {
					case 'controller':
					case 'action':
						$params[$key] = $value;
						break;
					default:
						$params[$key] = $item->$value;
				}
				$url = Smutty_Utils::getFullUrl( $params );
		}

		?>
		<item>
			<title><?= $title ?></title>
			<link><?= $url ?></link>
			<description><?= $desc ?></description>
		</item>
		<?

}

  echo '<?xml'; ?>
 version="1.0" encoding="UTF-8"<?php echo '?>'; ?>


<rss version="2.0">
	<channel>

		<title><?php echo ((is_array($_tmp=$this->_tpl_vars['modelName'])) ? $this->_run_mod_handler('pluralize', true, $_tmp) : smarty_modifier_pluralize($_tmp)); ?>
</title>
		<link><?php echo smarty_function_url_full(array('controller' => 'smutty','action' => 'rss','model' => 'page'), $this);?>
</link>
		<description>Feed of <?php echo ((is_array($_tmp=$this->_tpl_vars['modelName'])) ? $this->_run_mod_handler('pluralize', true, $_tmp) : smarty_modifier_pluralize($_tmp)); ?>
</description>
		<generator>Smutty RSS</generator>

		<?php $_from = $this->_tpl_vars['models']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['item']):
?>
			<?php renderRSSItem($this,$this->get_template_vars('item')) ?>
		<?php endforeach; endif; unset($_from); ?>

	</channel>
</rss>