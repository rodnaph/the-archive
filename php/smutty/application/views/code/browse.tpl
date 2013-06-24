
{include file="include/header.tpl" title="Browsing Code"}

<h2>Smutty Code</h2>

{include file="code/nav.tpl"}

{if $classes}
<h3>Classes</h3>
<ul>
{foreach item="class" from=$classes}
	<li>{link url={ action="viewClass" name=$class } text=$class }</li>
{/foreach}
</ul>
{/if}

{if $plugins}
<h3>Plugins</h3>
<ul>
{foreach item="plugin" from=$plugins}
	<li>{link url={ action="viewPlugin" type=$plugin[0] name=$plugin[1] } text=$plugin[2] }</li>
{/foreach}
{/if}

{include file="code/disclaimer.tpl"}

{include file="include/footer.tpl"}
