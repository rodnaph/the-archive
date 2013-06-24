
{include file="include/header.tpl" title="Task #`$task->id`: `$task->name`" section="Task"}

<script type="text/javascript" src="../javascript/tasks.js"></script>

<div class="Task">

	<h2><img src="../images/22x22/task.png" /> #{$task->id} - {$task->name|escape}</h2>

	<div id="RightWrap">
		<h3>Users</h3>
		<ul>
			<li>Rod</li>
			<li>Mark</li>
			<li>Kostas</li>
		</ul>
		<img src="../images/drop-arrow.png" />
		<div class="Note">(click to add users)</div>
	</div>

	<div>
		<label>Target</label>
		<div class="LabelValue">
			<a href="../targets/view.php?id=">v1.4</a> (2 Days)
			<img height="12" src="../images/drop-arrow.png" />
		</div>
		<label>Priority</label>
		<div class="LabelValue">{$task->priority->name|escape}
		{icon_small icon=$task->priority->icon}
		</div>
		<label>Status</label>
		<div class="LabelValue">{$task->status->name|escape}
		{icon_small icon=$task->status->icon}
		</div>
		<label>Type</label>
		<div class="LabelValue">{$task->type->name|escape}
		{icon_small icon=$task->type->icon}
		</div>
		<label>Project</label>
		<div class="LabelValue"><a href="../projects/view.php?id={$task->project->id}">{$task->project->name|escape}</a>
		{icon_small file="project.png"}
		</div>
	</div>
	
	<div style="clear:left;"></div>
	
	<p class="Body">{$task->description|format_text}</p>

	<div class="Actions">
		<input type="button" value="UPDATE TASK" onclick="showUpdateTaskWrap()" />
	</div>

</div>

<a name="UpdateTaskWrap"></a>

<div id="TaskUpdateWrap">

	<h3>Update Task</h3>

	<p>To update this task just enter...</p>

	{include file="tasks/task-form.tpl" task=$task}

</div>

{foreach item="hist" from=$task->getHistory()}

	<div class="TaskHistory">
		<div class="Info">
		<label>Updated</label>
		<div class="LabelValue">{$hist->dateCreated|format_datetime}
		- <b>{$hist->creator->name}</b></div>
		{if $hist->previous}
			{if $hist->previous->name != $hist->name}
				<label>Name</label>
				<div class="LabelValue">{$hist->name|escape}</div>
			{/if}
			{if $hist->previous->priority->id != $hist->priority->id}
				<label>Priority</label>
				<div class="LabelValue">{$hist->priority->name|escape}
				{icon_small icon=$hist->priority->icon}
				</div>
			{/if}
			{if $hist->previous->status->id != $hist->status->id}
				<label>Status</label>
				<div class="LabelValue">{$hist->status->name|escape}
				{icon_small icon=$hist->status->icon}
				</div>
			{/if}
			{if $hist->previous->type->id != $hist->type->id}
				<label>Type</label>
				<div class="LabelValue">{$hist->type->name|escape}
				{icon_small icon=$hist->type->icon}
				</div>
			{/if}
			{if $hist->previous->project->id != $hist->project->id}
				<label>Project</label>
				<div class="LabelValue"><a href="../projects/view.php?id={$hist->project->id}">{$hist->project->name|escape}</a>
				{icon_small file="project.png"}
				</div>
			{/if}
		{/if}
		{if $hist->getDocuments()}
			<label>Documents</label>
			<div class="LabelValue">
			{assign var="isFirst" value="1"}
			{foreach item="doc" from=$hist->getDocuments()}{if !$isFirst}, {/if}
				<a href="../docs/download.php?id={$doc->id}">{$doc->name|escape}</a> ({$doc->binSize|format_dataSize}){assign var="isFirst" value="0"}{/foreach}
			</div>
		{/if}
		</div>
		{if $hist->previous}
			<div class="Body">{$hist->description|format_text}</div>
		{else}
			<div class="Body">Task Submitted</div>
		{/if}
	</div>

{/foreach}

{include file="include/footer.tpl"}
