<?php

function smutty_function_tabgroup( $params, $smarty ) {

	$smarty->depend( 'modifier', 'escape' );
	$smarty->depend( 'function', 'ajax_libs' );

	$pages = v( $params, 'pages' );
	if ( !is_array($pageData) )
		$pages = Smutty_Utils::strToHash( $pages );
	$class = v( $params, 'class' );
	$linkStyle = $class ? ''
		: 'background-color:#ddd;' .
			'margin-right:10px;' .
			'padding:5px 10px 1px 10px;' .
			'border:1px #ddd solid;' .
			'border-bottom:none;' .
			'font-size:1.3em;';
	$html = '';

	$html .= smutty_function_ajax_libs( array(), $smarty );

	if ( !$class )
		$html .= '<style type="text/css">A.currentTab{font-weight:bold;}</style>';

	$html .= Smutty_Smarty::htmlElement( 'div', array(
		'id' => v( $params, 'id' ),
		'class' => $class
	), $smarty );

	foreach ( $pages as $id => $name )
		$html .= Smutty_Smarty::htmlElement( 'a', array(
			'id' => 'TabPageLink' . $id,
			'href' => 'javascript:smutty_tabPageShow(\'' . $id . '\');',
			'style' => $linkStyle
		), $smarty ) .
		smarty_modifier_escape($name) . '</a>';

	return $html .= '</div>';

}

function smarty_function_tabgroup( $params, $smarty ) {
	echo smutty_function_tabgroup( $params, $smarty );
}

?>
