
{include file="include/header.tpl" title="Documents" section="Docs"}

<h2>Files and Folders</h2>

<ul id="FolderItems"></ul>

<h3>Create Folder Here</h3>

<p>To create a new folder in this one, just enter it's name into
the form below and click the <b>Create</b> button.</p>

<form method="post" action="createFolder.php">
	<fieldset>

		<input type="hidden" name="todo" action="create-folder" />

		<label>Name:</label>
		<input type="text" name="name" />
		
		<input type="submit" value="Create" />

	</fieldset>
</form>

<script type="text/javascript" src="../javascript/folders.js"></script>
<script type="text/javascript">

var TYPE_FOLDER = '{$TYPE_FOLDER}';
var TYPE_FILE = '{$TYPE_FILE}';

refreshFolderView( {if $folderID}'{$folderID|escape}'{else}null{/if} );

</script>

{include file="include/footer.tpl"}
