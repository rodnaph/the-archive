<?php

function smarty_modifier_jsonize( $object ) {

	return Smutty_JSON::encode( $object );

}

?>