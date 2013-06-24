<?php

function smarty_modifier_pluralize( $phrase = "" ) {

	return Smutty_Inflector::pluralize( $phrase );

}

?>