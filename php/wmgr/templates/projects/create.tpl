
{include file="include/header.tpl" title="Create Project" section="Project"}

<script type="text/javascript" src="../javascript/projects.js"></script>
<script type="text/javascript" src="../javascript/explorer.js"></script>
<script type="text/javascript">

function explorerSelectionHandler( oItem ) {ldelim}

	var eID = document.getElementById( 'ParentID' );
	var eName = document.getElementById( 'ParentName' );

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

<h2><img src="../images/22x22/project.png" /> Creating a Project</h2>

<p>Blah blah...</p>

<form method="post" action="create.php">

	<fieldset>

		<input type="hidden" name="action" value="create-project" />
		<input type="hidden" name="parent" id="ParentID" value="" />

		<label for="name">Name:</label>
		<input type="text" name="name" />

		<label for="group">Group:</label>
		<select name="group" onchange="projectSelectionHandler(null)" id="ProjectGroup">
			<option value="">Select...</option>
			{foreach item="group" from=$user->getGroups()}
			<option value="{$group->id}">{$group->name|escape}</option>
			{/foreach}
		</select>

		<label for="parent_name">Parent:</label>
		<input type="text" readonly="readonly" name="parent_name" id="ParentName" />
		<input type="button" value=".." class="Elipsis" onclick="openExplorer(new ProjectProvider())" />

		<input type="submit" value="Create Project" />

	</fieldset>

</form>

{include file="include/footer.tpl"}
