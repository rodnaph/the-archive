<?php

/**
 *  this class provides the smarty plugin functionality for
 *  Smutty.  the plugins usually just pass off their work here
 *  so that it can be centralised and unit tested.
 *
 */

class Smutty_Smarty extends Smutty_Object {

	/**
	 *  returns a "real" field name for a "shortcut" field name
	 *
	 *  eg.  user.body becomes user[body]
	 *
	 *  @param String $str the shortcut field name
	 *  @return String the real field name
	 *
	 */

	public static function getFieldName( $str ) {

		$parts = explode( '.', $str );

		return sizeof($parts) == 1
			? $parts[0] : $parts[0] . '[' . $parts[1] . ']';

	}

	/**
	 *  returns an HTML element with the specified attributes
	 *
	 *  @param array $params parameters
	 *  @param Smarty $smarty smarty object
	 *  @return String html element string
	 *
	 */

	public static function htmlElement( $name, $attrs, $smarty ) {

		$name = strtolower( $name );
		$singles = array( 'link', 'input', 'hr', 'br' );
		$isSingle = false;

		// is it a single element?
		foreach ( $singles as $single )
			if ( $single == $name ) {
				$isSingle = true;
				break;
			}

		// now put the element together
		$elem = '<' . $name . self::buildAttrString($attrs,$smarty);
		if ( $isSingle )
			$elem .= ' />';
		else
			$elem .= '>';

		return $elem;

	}

	/**
	 *  builds an element attributes string from a hash
	 *
	 *  @param array $attrs assoc array of attributes
	 *  @param Smarty $smarty the smarty object
	 *  @return String the attribute string
	 *
	 */

	public static function buildAttrString( $attrs, $smarty ) {

		$smarty->depend( 'modifier', 'escape' );

		// build the attribute string
		$attrString = '';
		foreach ( $attrs as $key => $value )
			if ( $value )
				$attrString .= ' ' . $key . '="' . smarty_modifier_escape($value) . '"';

		return $attrString;

	}

}

?>