
{include file="include/header.tpl" title="Deleting a Page" section="Page"}

<h2><img src="../images/22x22/delete.png" /> Deleting a Page</h2>

<p class="Critical"><b>Warning:</b> you are about to delete a page, this operation
is not reversible and when completed there will be no way of getting your
page back.  You have been warned!</p>

<form method="get" action="view.php">
	<fieldset>
		<input type="hidden" name="id" value="{$page->id}" />
		<input type="submit" value="NOOOO!  What was I thinking?!?  Take me back to the page!" />
	</fieldset>
</form>

<p>If you are absolutely sure you want to <b>PERMANENTLY</b> delete this page then
click the following button.</p>

<form method="post" action="delete.php">
	<fieldset>
		<input type="hidden" name="todo" value="delete-page" />
		<input type="hidden" name="id" value="{$page->id}" />
		<input type="submit" value="Delete Page" />
	</fieldset>
</form>

{include file="include/footer.tpl"}
