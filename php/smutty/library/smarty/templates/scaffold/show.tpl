
{include file="include/header.tpl" title="Viewing a record"}

{if $model}

<h1>Viewing record #{$model->id}</h1>

<p>
	{link text="View All"}
</p>

{else}
<h1>Record not found</h1>
{/if}

{include file="include/footer.tpl"}
