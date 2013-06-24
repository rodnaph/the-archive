
{include file="include/header.tpl" title="Project: `$project->name`" section="Project"}

<h2><img src="../images/22x22/project.png" /> {$project->name|escape}</h2>

<p><i>
{foreach item="anc" from=$project->getAncestors()}
	<a href="view.php?id={$anc->id}">{$anc->name|escape}</a> ->
{/foreach}
	{$project->name|escape}
</i></p>

{if $project->getPage()}
	{php}
		$project = $this->get_template_vars( 'project' );
		$this->assign( 'page', $project->getPage() );
	{/php}
	<p>{$page|page_formatBody}</p>
	<p>
		<a href="../pages/edit.php?id={$page->id}&return=/projects/view.php?id={$project->id}">Edit</a> |
		<a href="page.php">Change</a>
	</p>
{else}
	<p><b>NB:</b> You haven't selected a page to use for this project, you
	can do this by <a href="page.php">clicking here</a>.</p>
{/if}

<div class="Dashbox">
	<h3><img src="../images/22x22/task.png" /> Latest Tasks</h3>
	<div class="Content">
	</div>
</div>

{include file="include/footer.tpl"}
