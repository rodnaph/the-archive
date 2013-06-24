
{include file="include/header.tpl" title="Plugin: `$name`"}

<h2>View Code: {$name|escape}</h2>

{include file="code/nav.tpl"}

{foreach key="no" item="line" from=$lines}
	<div class="codeline" style="clear:left;">
		<div class="number">{math equation="x + 1" x=$no}</div>
		<div class="content">{$line|linkcode}</div>
	</div>
{/foreach}

<div class="clearer"></div>

{include file="code/disclaimer.tpl"}

{include file="include/footer.tpl"}
