
{assign var="modelPlural" value=$modelClass|pluralize}
{include file="include/header.tpl" title="Browse `$modelPlural`"}

{include file="smutty/modelRelated.tpl" model=""}

{if $total > $perPage}
<p>
<b>Pages:</b>

{paginate
	url={ action="modelBrowse" smutty_modelClass=$modelClass }
	total=$total
	start=$start
	perPage="10"
}

</p>
{/if}

<table>
	<tr>
		<th class="link"></th>
		{foreach item="field" from=$fields}
			<th class="dataHeader">

				{$field->name|escape}

				<a href="?order={$field->name|escape}&amp;dir=asc"
					title="Ascending Order"><img
					src="{url controller="smutty" action="resource"
					folder="images" file="tinyarrow-up.png" }" /></a><a
				title="Descending Order" href="?order={$field->name|escape}&amp;dir=desc""><img
					src="{url controller="smutty" action="resource"
					folder="images" file="tinyarrow-down.png" }" /></a>

			</th>
		{/foreach}
	</tr>
	{foreach item="model" from=$models}
	<tr>
		<td class="link">
			<a href="{url action="modelShow" smutty_modelClass=$modelClass smutty_modelId=$model->id }" title="View Record"><img
				src="{url action="resource" folder="icons" file="show.png" }" /></a>
			<a href="{url action="modelEdit" smutty_modelClass=$modelClass smutty_modelId=$model->id }" title="Edit Record"><img
				src="{url action="resource" folder="icons" file="edit.png" }" /></a>
			<a href="{url action="modelDelete" smutty_modelClass=$modelClass smutty_modelId=$model->id }" title="Delete Record"><img
				src="{url action="resource" folder="icons" file="delete.png" }" /></a>
		</td>
		{foreach item="field" from=$fields}
			{assign var="name" value=$field->name}
			{assign var="value" value=$model->$name}
			<td>
				{if is_object($value)}
					{link url={ action="modelShow" smutty_modelClass=$name smutty_modelId=$value->id } text=$value->name }
				{else}
					{$model->$name|escape|truncate:"30"}
				{/if}
			</td>
		{/foreach}
	</tr>
	{foreachelse}
	<tr>
		{php}$this->assign('colCount',sizeof($this->get_template_vars('fields'))+1);{/php}
		<td colspan="{$colCount}">
			No records found...
		</td>
	</tr>
	{/foreach}
</table>

{include file="include/footer.tpl"}
