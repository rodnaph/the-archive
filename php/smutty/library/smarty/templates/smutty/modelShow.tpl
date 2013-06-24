
{if $model->name}
	{assign var="modelDesc" value=$model->name}
{else}
	{assign var="modelDesc" value=$model->id}
{/if}

{include file="include/header.tpl" title="$modelClass `$modelDesc`"}

{if $model}

<div class="data">

{foreach item="field" from=$fields}
	{assign var="name" value=$field->name}
	{assign var="value" value=$model->$name}
	{label text=$name}
		<div class="value">
		{if is_object($value)}
			{link url={ action="modelShow" smutty_modelClass=$name smutty_modelId=$value->id } text=$value->name }
		{else}
			{$value|escape}
		{/if}
		&nbsp;
		</div>
{/foreach}

{form method="get" url={ action="modelEdit"
	smutty_modelClass=$modelClass smutty_modelId=$modelId } }
	{submit text="Edit Record"}
{form_end}

</div>

<div class="clearer"></div>

{else}
<h3>Record Not Found</h3>
<p>The record you requested was not found.</p>
{/if}

{include file="include/footer.tpl"}
