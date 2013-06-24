
{include file="include/header.tpl" title="Edit: `$pageName`"}

{if !$smutty->user}

<h2 class="error">Error</h2>

<p>You must be {link controller="user" action="login" text="logged in"}
to edit pages.</p>

{else}

<h2>Edit: {$pageName|escape}</h2>

{if $errors}
	<h3 class="error">Error Saving</h3>
	<ul>
	{foreach item="error" from=$errors}
		<li>{$error}</li>
	{/foreach}
	</ul>
{/if}

<form method="post" action="{url action="save" name=$pageName}">

	<fieldset>

		<textarea class="wide" name="body" cols="80" rows="20">{if $pageBody}{$pageBody|escape}{else}{$page->body|escape}{/if}</textarea>

		<input type="submit" value="Save Changes" style="margin:10px 0px 10px 0px;" />

	</fieldset>

</form>

{/if}

{include file="include/footer.tpl"}
