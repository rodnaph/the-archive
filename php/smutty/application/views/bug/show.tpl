
{include file="include/header.tpl" title="Bug #`$bug->id`: `$bug->name`" enableAjax="true"}

<h2>Bug #{$bug->id}: {$bug->name|escape}</h2>

<div id="bugInfo">

<b>User:</b> {$bug->user_name|escape}<br />
<b>Status:</b> {$bug->bug_status->name}<br />
<b>Posted:</b> {$bug->date_created|date_format:"%y/%m/%d"}

</div>

<div id="bugMain">

	<b>Description:</b>
	<div class="bugDesc">{$bug->body|safehtml}</div>

</div>

<div id="bugComments">

	{foreach item="comment" from=$bug->bug_comments}
		<div class="bugComment">
			<div>Comment by <b>{$comment->user_name|escape}</b></div>
			<div class="body">{$comment->body|safehtml}</div>
		</div>
	{/foreach}

</div>

<div id="commentResult"></div>

<h3>Add a comment</h3>

{form url={ action="comment" id=$bug->id }
	update="commentResult"
	feedback="commentResult" }

	<fieldset>

	{if !$smutty->session->user}
		{field label="Name:" name="bug_comment.user_name"}
	{/if}

	{select from=$bugStatus selected=$bug->bug_status->id
		label="Status:" name="bug_status_id" }

	{textarea name="bug_comment.body" label="Comments"}

	{submit text="Post comment"}

	</fieldset>

{form_end}

{include file="bug/sidebar.tpl"}
{include file="include/footer.tpl"}
