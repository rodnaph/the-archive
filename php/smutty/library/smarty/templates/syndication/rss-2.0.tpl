{php}

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

{/php}
<?xml version="1.0" encoding="UTF-8"?>

<rss version="2.0">
	<channel>

		<title>{$modelName|pluralize}</title>
		<link>{url_full controller="smutty" action="rss" model="page" }</link>
		<description>Feed of {$modelName|pluralize}</description>
		<generator>Smutty RSS</generator>

		{foreach item="item" from=$models}
			{php}renderRSSItem($this,$this->get_template_vars('item')){/php}
		{/foreach}

	</channel>
</rss>
