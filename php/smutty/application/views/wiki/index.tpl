
{include file="include/header.tpl" title="`$page->name`"}

<h2>{$page->name|escape}</h2>

<p>{$page->body|wikitext}</p>

<p>
	{if $smutty->user or ($page->name ne "MainPage")}<b>Links:</b>{/if}
	{if $smutty->user}
		{link url={ action="edit" name=$page->name } text="Edit this page"}
	{/if}
	{if $page->name ne "MainPage"}
		{if $smutty->user}&middot;{/if}
		{link url={ action="comment" name=$page->name } text="Post a comment"}
	{/if}
</p>

{if $page->comments}
	{foreach item="comment" from=$page->comments}
		<h4>Posted by {$comment->name|escape} on {$comment->date_posted|date_format:"%b %e"}</h4>
		<p style="border:1px #ddd solid;background-color:#eee;padding:5px 10px 5px 10px;">{$comment->body|escape|nl2br}</p>
	{/foreach}
{/if}

{include file="include/sidebar.tpl"}

{include file="include/footer.tpl"}
