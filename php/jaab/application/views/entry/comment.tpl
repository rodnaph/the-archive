
{include file="include/header.tpl" title="Posting a Comment"}

<h2>Posting a Comment</h2>

<p>To post a comment just fill in the fields and hit the <b>post</b> button.  You
don't have to be logged in, but if you're not then you won't be able to use
your username.</p>

{show_errors}

{form url={ action="commentSave" id=$entry->id } }

	<fieldset>

	{if !$session->user}
		{field name="username" label="Name:}
	{/if}

	{field name="comment.subject" label="Title:" value="Re: `$entry->subject`" }

	{textarea name="comment.body" label="Comments:"}

	{submit text="Post Comment"}

	</fieldset>

{form_end}

{include file="include/footer.tpl"}
