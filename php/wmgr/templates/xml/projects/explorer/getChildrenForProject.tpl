{include file="include/header-xml.tpl"}

<children>
	{foreach item="project" from=$children}
	<project id="{$project->id}" childCount="{$project->childCount}">
		<name>{$project->name|escape}</name>
	</project>
	{/foreach}
</children>
