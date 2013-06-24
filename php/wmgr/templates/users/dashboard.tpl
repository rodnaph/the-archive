
{include file="include/header.tpl" title="Dashboard"}

<h2><img src="../images/22x22/dash.png" /> Dashboard</h2>

{include file="tasks/dashbox-latest.tpl"}

{if $user->getProjects()}
<div class="Dashbox">
	<h3><img src="../images/22x22/project.png" /> My Projects</h3>
	<ul>
	{foreach item="project" from=$user->getProjects()}
		<li><a href="../projects/view.php?id={$project->id}">{$project->name|escape}</a></li>
	{/foreach}
	</ul>
</div>
{/if}

{if $user->getGroups()}
<div class="Dashbox">
	<h3><img src="../images/22x22/group.png" /> My Groups</h3>
	<ul>
	{foreach item="group" from=$user->getGroups()}
		<li><a href="../groups/view.php?id={$group->id}">{$group->name|escape}</a></li>
	{/foreach}
	</ul>
</div>
{/if}

<div class="Dashbox">

	<h3><img src="../images/22x22/group.png" /> Latest Groups</h3>

	{if $latestGroups}
	<ul>
		{foreach item="group" from=$latestGroups}
			<li><a href="../groups/view.php?id={$group->id}">{$group->name|escape}</a></li>
		{/foreach}
	</ul>
	{else}
		<p>No groups... <a href="../groups/create.php">create one</a>!</p>
	{/if}

	{if $latestGroups}
		<p class="Links">
		<a href="../groups/create.php">create</a> -
		<a href="../groups/">explore</a>
		</p>
	{/if}

</div>

<div class="Dashbox">
	<h3>My Projects</h3>
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
</div>

<div class="Dashbox">
	<h3>My Links</h3>
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
	hsd ahjsd haks dhasj dhas jdhas djkas hdjasd
</div>

<div class="Dashbox">
	<h3>New Documents</h3>
	There are no new documents...
</div>

{include file="include/footer.tpl"}
