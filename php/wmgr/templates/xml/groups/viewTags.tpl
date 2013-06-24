{php}
	header( 'Content-type: text/xml' );
{/php}
<?xml version="1.0" encoding="ISO-8859-1"?>

<group id="{$group->id}">

	<tags>
		{foreach item="tag" from=$group->getTags()}
		<tag id="{$tag->id}">{$tag->name|escape}</tag>
		{/foreach}
	</tags>

</group>
