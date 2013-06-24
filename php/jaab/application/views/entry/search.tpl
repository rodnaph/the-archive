
{include file="include/header.tpl"}

<h2>Searching Entries</h2>

<p>Stick whatever you want to find into the fields and click <b>search</b>!</p>

{form url={ action="search" } method="get" id="SearchForm" }

	{field name="q" label="Keywords:" value=$q}

	{select name="userId" from=$users label="User:" selected=$userId}

	{select name="location" from=$countries group="locations"
		label="Location:" selected=$location}

	{submit text="Search"}

{form_end}

<div style="clear:left"></div>

<br />

<p>Pages:
{paginate
	url={ action="search" }
	total=$total
	perPage=$perPage
	start=$start
}
</p>

{foreach item="entry" from=$entries}
<p>
	<h3>{link url={ action="show" id=$entry->id } text=$entry->subject }</h3>
	<div class="descr">{$entry->date|date_format:"%a, %b %e"} by {$entry->user->name|escape}</div>
	<code>
		{$entry->body|escape|truncate:"100"}
		<br /><br />
		<b>{$entry->location->name}
		{if $entry->comments}
			- {$entry->comments|@sizeof} comments
		{/if}</b>
	</code>
</p>
{/foreach}

<br /><br /><br />


<p>
{if $less}
	{link form="SearchForm" args={ start=$lessStart } text="Less"}
{/if}
{if $more && $less} or {/if}
{if $more}
	{link form="SearchForm" args={ start=$moreStart } text="More"}
{/if}
</p>

{include file="include/footer.tpl"}
