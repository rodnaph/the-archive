<?php

function smarty_modifier_plural( $number, $singular ) {

	if ( is_array($number) )
		$number = sizeof( $number );

	return $number . ' ' .
		(( $number == 1 )
			? $singular
			: Smutty_Inflector::pluralize($singular));

}

?>