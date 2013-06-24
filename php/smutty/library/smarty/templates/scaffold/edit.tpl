
{include file="include/header.tpl" title="Editing Record"}
{php}

function getFieldValue( $smarty ) {
	$field = $smarty->get_template_vars( 'field' );
	$model = $smarty->get_template_vars( 'model' );
	$name = $field->name;
	return $model->$name;
}

// set day options
$dayOptions = array( '' );
for ( $i=1; $i<32; $i++ )
	$dayOptions[$i] = $i;
$this->assign( 'dayOptions', $dayOptions );

// set month options
$monthOptions = array( '' );
for ( $i=1; $i<13; $i++ )
	$monthOptions[$i] = $i;
$this->assign( 'monthOptions', $monthOptions );

// set year options
$yearOptions = array( '' );
for ( $i=2000; $i<2020; $i++ )
	$yearOptions[$i] = $i;
$this->assign( 'yearOptions', $yearOptions );

{/php}

<h1>{if $model}Editing{else}Adding{/if} a Record</h1>

<form method="post" action="{url action="save" id=$model->id}">

	<fieldset>

		<legend>Record Information</legend>

		{foreach item="field" from=$fields}

			{if ($field->type eq "int"
					|| $field->type eq "varchar"
					|| $field->type eq "char")
				&& $field->name ne "id"}
				<label for="{$field->name|escape}">{$field->name|escape}:</label>
				{php}$this->assign( 'fieldValue', getFieldValue($this) );{/php}
				<input type="text" name="{$field->name|escape}" value="{$fieldValue}" />

			{elseif $field->type eq "datetime"}
				<label>{$field->name|escape}:</label>
				{html_options name="dd_`$field->name`" options=$dayOptions}
				{html_options name="dm_`$field->name`" options=$monthOptions}
				{html_options name="dy_`$field->name`" options=$yearOptions}

			{elseif $field->type eq "text"}
				{php}$this->assign( 'fieldValue', getFieldValue($this) );{/php}
				<label>{$field->name|escape}:</label>
				<textarea name="{$field->name|escape}">{$fieldValue|escape}</textarea>
			{/if}

		{/foreach}

		<input type="submit" value="Save Record" />

	</fieldset>

</form>

{include file="include/footer.tpl"}
