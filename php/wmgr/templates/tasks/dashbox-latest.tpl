
<div class="Dashbox">
	<h3><img src="../images/22x22/task.png" /> Latest Tasks</h3>
	These are your 10 latest tasks.
	<ul>
	{foreach item="task" from=$user->getLatestTasks()}
		<li style="list-style-image:url(../images/12x12/{$task->status->icon->filename});">
		<a href="{$URL_BASE}/tasks/view.php?id={$task->id}">#{$task->id}: {$task->name|escape}</a>
		</li>
	{/foreach}
	</ul>
</div>
