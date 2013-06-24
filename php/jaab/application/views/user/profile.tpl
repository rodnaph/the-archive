
{include file="include/header.tpl" title="Profile: `$user->name`"}

{if $user}

<h2>Profile: {$user->name|escape}</h2>

<h3>Recent Comments</h3>
{foreach item="comment" from=$comments}
<div>
	{link class="descr"
		url={ controller="entry" action="show" id=$comment->thread }
		text=$comment->subject}
	{if $comment->replies}({$comment->replies|@sizeof} replies){/if}
</div>
{foreachelse}
<p>No comments...</p>
{/foreach}

{else}
<h2>User not found!</h2>
{/if}

{include file="include/footer.tpl"}
