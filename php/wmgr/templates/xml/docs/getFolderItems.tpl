{include file="include/header-xml.tpl"}

<items>
	{foreach item="item" from=$items}
	<item id="{$item->id}" type="{$item->type}">
		<name>{$item->name|escape}</name>
	</item>
	{/foreach}
</items>
