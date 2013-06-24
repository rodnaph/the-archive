
{include file="include/header.tpl" title="Page: `$page->name`" section="Page"}
{include file="include/pages/menu.tpl"}

<h2><img src="../images/22x22/page.png" /> {$page->name|escape}</h2>

<p><i>
{assign var="ancName" value=""}
{foreach item="anc" from=$page->getAncestors()}
	<a href="view.php?id={$anc->id}">{$anc->name|regex_replace:"/$ancName - /":""|escape}</a> ->
	{assign var="ancName" value=$anc->name}
{/foreach}
{$page->name|regex_replace:"/$ancName - /":""|escape}
</i></p>

<div class="PageBody">{$page|page_formatBody}</div>

{if $children}
<h3>Sub-Pages</h3>
<ul>
{foreach item="child" from=$children}
	<li><a href="view.php?id={$child->id}">{$child->name|regex_replace:"/`$page->name` - /":""|escape}</a></li>
{/foreach}
</ul>
{/if}

<p class="PageInfo">Edited by <a href="../users/view.php?id={$page->user->id}">{$page->user->name|escape}</a> at {$page->dateEdited|format_datetime}</p>

{include file="include/footer.tpl"}
