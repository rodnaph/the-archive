
<ul>
{foreach item="project" from=$projects}
	{if $project->parentID eq $parentID}
	<li>
		<a href="{$URL_BASE}/projects/view.php?id={$project->id}">{$project->name|escape}</a>
		{include file="projects/project-tree.tpl" parentID=$project->id}
	</li>
	{/if}
{/foreach}
</ul>
