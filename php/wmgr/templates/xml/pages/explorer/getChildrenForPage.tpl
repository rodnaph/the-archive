{include file="include/header-xml.tpl"}

<page>
	<children>
	{foreach item="page" from=$children}
		<page id="{$page->id}" childCount="{$page->childCount}">
			<name>{$page->name|escape}</name>
		</page>
	{/foreach}
	</children>
</page>