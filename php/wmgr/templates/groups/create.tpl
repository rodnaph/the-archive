
{include file="include/header.tpl" title="Creating a group" section="Group"}

<h2><img src="../images/22x22/group.png" /> Creating a new group</h2>

<p>Groups form the basis for all access and grouping of everything, so they're
pretty important.</p>

<form method="post" action="create.php">

	<fieldset>

		<input type="hidden" name="action" value="create-group" />

		<label for="name">Name:</label>
		<input type="text" name="name" />

		<input type="submit" value="Create group!" />

	</fieldset>

</form>

{include file="include/footer.tpl"}
