<?php

function smutty_function_tabpage( $params, $smarty ) {

	$style = 'display:none;';
	$class = v( $params, 'class' );
	$id = v( $params, 'id' );
	$html = '';

	if ( !$id )
		Smutty_Error::fatal( 'you need to specify an "id" for tab pages', 'SmuttyViews' );

	if ( !$class )
		$style .= 'background-color:#ddd;' .
			'border:1px #777 solid;' .
			'padding:10px;';

	$html .= Smutty_Smarty::htmlElement( 'div', array(
		'class' => $class,
		'style' => $style,
		'id' => $id
	), $smarty );

	if ( v($params,'default') == 'yes' )
		$html .= '<script type="text/javascript">' .
			'smutty_tabPageShow(\'' . $id . '\');' .
			'</script>';

	return $html;

}

function smarty_function_tabpage( $params, $smarty ) {
	echo smutty_function_tabpage( $params, $smarty );
}

?>