
{include file="include/header.tpl" title="Projects" section="Project"}

<h2><img src="../images/22x22/project.png" /> All Projects</h2>

{foreach item="group" from=$groups}

	{if $group->getProjects()}

		<h3><img src="../images/12x12/group.png" /> {$group->name|escape}</h3>

		{include file="projects/project-tree.tpl" projects=$group->getProjects()}

	{/if}

{/foreach}

{include file="include/footer.tpl"}
