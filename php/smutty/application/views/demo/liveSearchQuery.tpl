
<ul>
{if $pages}
	{foreach item="page" from=$pages}
		<li>{link url={ controller="wiki" name=$page->name } text=$page->name}</li>
	{/foreach}
{else}
	<li>Nothing found...</li>
{/if}
</ul>