
{include file="include/header.tpl"}

<h2>{$entry->subject|escape}</h2>

<h3>Posted by {$entry->user->name} on {$entry->date|date_format:"%A, %b %d"}</h3>

{$entry->body|safehtml}

{if $entry->comments}
<p>
	<h2>Comments</h2>
	<br />
	{foreach item="comment" from=$entry->comments}
		<h4>{$comment->subject}</h4>
		<div class="descr">{$comment->date|date_format:"%A, %b %d"}
			by
			{if $comment->user}
				{$comment->user->name|escape}
			{else}
				{$comment->name|escape}
			{/if}
		</div>
		<code>{$comment->body|safehtml}</code>
	{/foreach}
</p>
{else}
	<br /><br />
{/if}

<p>{link url={ action="comment" id=$entry->id } text="Post New Comment" }</p>

{include file="include/footer.tpl"}
