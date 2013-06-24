
{include file="include/header.tpl"}

{foreach item="entry" from=$entries}

	<h2>{link url={ action="show" id=$entry->id } text=$entry->subject }</h2>

	{$entry->body|truncate:"1000"|safehtml}

	<p class="date">Posted by {$entry->user->name}
		<img src="images/more.gif" alt="" />
		{$entry->location->name|escape}
		<img src="images/comment.gif" alt="" />
		<a href="{url action="show" id=$entry->id}#comments">Comments ({$entry->comments|@sizeof})</a>
		<img src="images/timeicon.gif" alt="" />
	{$entry->date|date_format:"%A, %b %d"}</p>

	<br />

{/foreach}

{include file="include/footer.tpl"}
