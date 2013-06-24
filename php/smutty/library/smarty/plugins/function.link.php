<?php

/**
 *  returns the html for an anchor element.  this could be some
 *  kind of javascript/ajax call if you use the right args.
 *
 *  @param array $params assoc array of params
 *  @param Smarty $smarty the smarty object
 *  @return html
 *
 */

function smutty_function_link( $params, $smarty ) {

	// make sure we have dependent plugins
	$smarty->depend( 'modifier', 'escape' );

	// fetch the url for the request
	$urlHash = array();
	if ( isset($params['url']) )
		$urlHash = is_array($params['url']) ? $params['url'] : Smutty_Utils::strToHash($params['url']);
	$args = array();
	if ( isset($params['args']) )
		$args = is_array($params['args']) ? $params['args'] : Smutty_Utils::strToHash($params['args']);
	$url = Smutty_Utils::getUrl( $urlHash );
	$update = v($params,'update');
	$handler = v($params,'handler');
	$feedback = v($params,'feedback');
	$text = w( $params, 'text', ucfirst(v($urlHash,'action')) );
	$form = v($params,'form');
	$class = v($params,'class');
	$image = v( $params, 'image' );
	$id = '';

	// select the link maybe?
	if ( function_exists('smutty_function_linkSelectText') )
		if ( $select = smutty_function_linkSelectText() )
			if ( $select['text'] == $text ) {
				$id = W( $select, 'id', $id );
				$class = W( $select, 'class', $class );
			}

	// link element (text or image)
	$linkElement = $image
		? Smutty_Smarty::htmlElement( 'img', array(
				'src' => Smutty_Utils::getBaseUrl() . $image,
				'alt' => v( $params, 'alt' )
			), $smarty )
		: smarty_modifier_escape( $text );

	// is it an ajax link?
	if ( $update ) {
		if ( v($params,'gpgSigned') )
			$url .= ENIGFORM_SIG;
		return '<a href="javascript:smutty_ajaxCall(' .
				'\'' . $url . '\',' .
				'\'' . $update . '\',' .
				'\'' . $handler . '\',' .
				'null,' .
				'\'' . $feedback . '\'' .
			');">' . $linkElement . '</a>';
	}

	// is it a form link?
	elseif( $form ) {
		$argStr = '';
		foreach ( $args as $key => $value )
			if ( $key )
				$argStr .= ",$key:'$value'";
		$argStr = substr( $argStr, 1 );
		$js = 'f=document.getElementById(\'' . $form . '\');' .
			'a={' . $argStr . '};' .
			'for(x in a)f[x].value=a[x];' .
			'f.submit();';
		return '<a href="javascript:' . $js . '">' . $linkElement . '</a>';
	}

	// otherwise assume normal link
	else {
		$queryString = '';
		foreach ( $args as $key => $value )
			$queryString .= '&' . urlencode($key) . '=' . urlencode($value);
		$queryString = substr( $queryString, 1 );
		return Smutty_Smarty::htmlElement( 'a', array(
				'href' => $url . ( $queryString ? "?$queryString" : '' ),
				'class' => $class,
				'title' => v($params,'title'),
				'id' => $id
			), $smarty ) .
			$linkElement . '</a>';
	}

}

function smarty_function_link( $params, $smarty ) {
	echo smutty_function_link( $params, $smarty );
}

?>
