
<script type="text/javascript" src="{$URL_BASE}/javascript/projects.js"></script>
<script type="text/javascript" src="{$URL_BASE}/javascript/explorer.js"></script>
<script type="text/javascript">

function explorerSelectionHandler( oItem ) {ldelim}

	var eID = document.getElementById( 'ProjectID' );
	var eName = document.getElementById( 'ProjectName' );

	if ( oItem == null ) {ldelim}
		eID.value = '';
		eName.value = '';
	{rdelim}

	else {ldelim}
		eID.value = oItem.getID();
		eName.value = oItem.getName();
	{rdelim}

{rdelim}

</script>

<form method="post" action="{if $task}update{else}create{/if}.php" enctype="multipart/form-data">

	<fieldset>

		<input type="hidden" name="action" value="{if $task}update{else}create{/if}-task" />
		<input type="hidden" name="project" id="ProjectID" value="{$task->project->id}" />
		<input type="hidden" name="id" value="{$task->id}" />

		<label for="name">Name:</label>
		<input type="text" name="name" value="{$task->name|escape}" />

		<label for="project-name"><img src="../images/12x12/project.png" /> Project:</label>
		<input type="text" name="project-name" readonly="readonly" id="ProjectName" value="{$task->project->name}" />
		<input type="button" class="Elipsis" value=".." onclick="openExplorer(new ProjectProvider())" />

		<label for="status">Status:</label>
		<select name="status">
			<option value=""></option>
			{foreach item="status" from=$taskStatus}
				{html_option id=$status->id name=$status->name select=$task->status->id icon=$status->icon}
			{/foreach}
		</select>

		<label for="type">Type:</label>
		<select name="type">
			<option value=""></option>
			{foreach item="type" from=$taskTypes}
				{html_option id=$type->id name=$type->name select=$task->type->id icon=$type->icon}
			{/foreach}
		</select>

		<label for="priority">Priority:</label>
		<select name="priority">
			<option value=""></option>
			{foreach item="priority" from=$taskPriorities}
				{html_option id=$priority->id name=$priority->name select=$task->priority->id icon=$priority->icon}
			{/foreach}
		</select>

		<label for="doc[]">Attachment:</label>
		<input type="file" name="doc[]" /><input type="button" value="(more)" style="width:auto;" onclick="addAttachmentField()" />
		<div id="TaskUpdateDocs"></div>

		<label for="body">Comments:</label>
		<textarea name="body"></textarea>

		<input type="submit" value="{if $task}Update{else}Create{/if} Task" />

	</fieldset>

</form>
