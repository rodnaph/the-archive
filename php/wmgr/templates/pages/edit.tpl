
{include file="include/header.tpl" title="Edit Page" section="Page"}
{include file="include/pages/menu.tpl"}

<script type="text/javascript" src="../javascript/pages.js"></script>
<script type="text/javascript" src="../javascript/explorer.js"></script>

<h2><img src="../images/22x22/page.png" /> 
	{if $page}
	Edit: {$page->name|escape}
	{else}
	Creating a Page
	{/if}
</h2>

<p>
{if $page}
Editing a page, blah blah...
{else}
Creating a new page...
{/if}
</p>

<form method="post" action="edit.php">

	<fieldset>

		<input type="hidden" name="return" value="{$smarty.get.return|escape}" />
		<input type="hidden" name="parent" id="ParentID" value="{if $parent}{$parent->id}{else}{$page->parentID}{/if}" />

		{if $page}
			<input type="hidden" name="action" value="edit-page" />
			<input type="hidden" name="id" value="{$page->id}" />
			<input type="hidden" name="group_id" value="{$page->group->id}" />
			<label for="name">Name:</label>
			<input type="text" name="name" readonly="readonly" value="{$page->name|escape}" />
		{else}
			<input type="hidden" name="action" value="create-page" />
			<label for="name">Name:</label>
			{if $pageName}
			<input type="text" readonly="readonly" name="name" value="{$pageName|escape}" />
			{else}
			<input type="text" name="name" value="{$pageName|escape}" />
			{/if}
		{/if}

		{if !$page && !$groupID}
		<label for="group">Group:</label>
		<select name="group_id" onchange="pageSelectionHandler(null);">
			{foreach item="group" from=$user->getGroups()}
			<option{if $group->id eq $groupID} selected="selected"{/if} value="{$group->id}">{$group->name|escape}</option>
			{/foreach}
		</select>
		{elseif !$page && $groupID}
		<input type="hidden" name="group_id" value="{$groupID|escape}" />
		{/if}

		<label for="parent-name">Parent:</label>
		<input type="text" name="parent-name" readonly="readonly" id="ParentName" value="{if $parent}{$parent->name|escape}{else}{$parentName|escape}{/if}" />
		<input type="button" class="Elipsis" value=".." onclick="openExplorer(new GroupProvider(this.form.group_id.value));" />

		<label for="body">Body:</label>
		<textarea name="body" rows="15">{$page->body|escape}</textarea>

		<input type="submit" value="{if $page}Save Changes{else}Create Page{/if}" />

	</fieldset>

</form>

{include file="include/footer.tpl"}
