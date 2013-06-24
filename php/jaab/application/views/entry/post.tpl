
{include file="include/header.tpl" ajax="true"}

<h2>Posting An Entry</h2>

<p>To post an entry just enter the
info into the fields below and click on the <b>post</b> button.</p>

{show_errors}

{form url={ action="save" } }

	<fieldset>

	{select name="entry.location" from=$countries
		group="locations"
		label="Location:" selected=$user->current_location}

	{field name="entry.subject" label="Subject:"}

	{textarea name="entry.body" label="Description:"}

	{submit text="Post Entry"}

	{button text="Preview (below)"
		url={ action="postPreview" }
		update="PostPreview"}

	</fieldset>

{form_end}

<div id="PostPreview"></div>

<div class="clearer"></div>

{include file="include/footer.tpl"}
