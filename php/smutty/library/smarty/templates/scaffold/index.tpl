
{include file="include/header.tpl" title=""}

{if $modelName}

<h1>{$modelName|escape|pluralize}</h1>

<table>
	<tr>
		<th></th>
		{foreach item="field" from=$fields}
		<th>{$field->name|escape}</th>
		{/foreach}
	</tr>
	{foreach item="model" from=$models}
		<tr>
		<td>
			{link action="show" id=$model->id text="View"} /
			{link action="edit" id=$model->id text="Edit"}
		</td>
		{foreach item="field" from=$fields}
			<td>
			{php}
				$model = $this->get_template_vars( 'model' );
				$field = $this->get_template_vars( 'field' );
				$name = $field->name;
				$this->assign( 'fieldValue', $model->$name );
			{/php}
			{$fieldValue|escape}
			</td>
		{/foreach}
		</tr>
	{/foreach}
</table>

<p>[ {link action="edit" text="Create New Record"} ]</p>

{else}

<h1>No Model Found</h1>

<p>There was no model found for this controller. To add one just...</p>

{/if}

{include file="include/footer.tpl"}
