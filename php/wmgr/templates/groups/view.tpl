
{include file="include/header.tpl" title="Group: `$group->name`" section="Group"}

<script type="text/javascript" src="../javascript/groups.js"></script>
<script type="text/javascript">

var gCreate = new Menu( 'Create' );
gCreate.add( new Menu('Page','/pages/edit.php?group_id={$group->id}','page.png') );
gCreate.add( new Menu('Project','/projects/create.php?group_id={$group->id}','project.png') );

var group = new Menu( 'Group',null,'group.png' );
group.add( new Menu('Home','/groups/view.php?id={$group->id}') );
group.add( gCreate );
group.init();

</script>

<h2><img src="../images/22x22/group.png" /> {$group->name|escape}</h2>

{if $group->isPending($user)}
	<p><b>Alert:</b> You have requested to join this group, if you like
	you can <a href="joinCancel.php?id={$group->id}">cancel your request</a>.</p>
{/if}

<p>

	<b>Users:</b>
	{foreach item="u" from=$group->getUsers()}
		{$u->name|escape}
	{/foreach}

	{if sizeof($group->getPendingUsers())}
		(<a href="pending.php?id={$group->id}">{$group->getPendingUsersCount()} pending</a>)
	{/if}

</p>

{if $group->isMember($user)}
<p>
	<b>Tags:</b>
	<input type="text" id="GroupTags" onfocus="updateTagsButton(true)"
		onblur="setTimeout('updateTagsButton(false)',1000);"
		value="{foreach item="tag" from=$group->getTags()}{$tag->name|escape} {/foreach}" />
	<input type="button" value="Update" id="GroupUpdateTags"
		onclick="updateGroupTags({$group->id})" />
</p>
{/if}

<p>
	{if !$group->isMember($user) && !$group->isPending($user)}
		<input type="button" id="GroupJoinButton" value="Join Group" onclick="self.location.href='joinRequest.php?id={$group->id}';" />
	{/if}
</p>

{if $group->isMember($user)}

	{if $group->getProjects()}
	<div class="Dashbox">
		<h3><img src="../images/22x22/project.png" /> Projects</h3>
		<ul>
			{foreach item="project" from=$group->getProjects()}
			<li><a href="../projects/view.php?id={$project->id}">{$project->name|escape}</a></li>
			{/foreach}
		</ul>
		<p class="Links">
			<a href="../projects/create.php">create</a> -
			<a href="../projects/">explore</a>
		</p>
	</div>
	{/if}
	
	{if $group->getLatestPages()}
	<div class="Dashbox">
		<h3><img src="../images/22x22/page.png" /> New Pages</h3>
		<ul>
			{foreach item="page" from=$group->getLatestPages()}
			<li><a href="../pages/view.php?id={$page->id}">{$page->name|escape}</a></li>
			{/foreach}
		</ul>
	</div>
	{/if}

{/if}

{include file="include/footer.tpl"}
