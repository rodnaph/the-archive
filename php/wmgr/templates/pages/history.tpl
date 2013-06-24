
{include file="include/header.tpl" title="Page History: `$page->name`" section="Page"}
{include file="include/pages/menu.tpl"}

<h2>Page History: {$page->name|escape}</h2>

{foreach item="history" from=$page->getHistory()}
<p>Edited by {$history->user->name|escape} at {$history->dateEdited|format_datetime}</p>
{/foreach}

{include file="include/footer.tpl"}
