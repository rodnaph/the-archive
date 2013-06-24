{php}

/**
 *  this function looks for related data, a table with
 *  records that are reference from the specifed field.
 *  if found it'll return an array (WHICH MAY BE EMPTY!)
 *  otherwise it'll return false;
 *
 *  @param [model] the model to check
 *  @param [field] the field to check for
 *  @return Array/false
 *
 */

function getRelatedData( $model, $field ) {

	$relatedClass = false;
	$models = false;

	//
	//  check explicit $hasOne relations
	//
	if ( $model->hasOne ) {
		$parts = explode( ' ', $model->hasOne );
		foreach ( $parts as $hasOne ) {
			$bits = explode( '.', $hasOne );
			$class = $bits[ 0 ];
			$name = $bits[1] ? $bits[1] : strtolower($class) . '_id';
			if ( ($name == $field->name) && class_exists($class) )
				$relatedClass = $class;
		}
	}

	//
	//  look for _id fields (if we haven't already found
	//  a related class that is)
	//
	if ( !$relatedClass && (substr($field->name,-3) == '_id') ) {
		$class = ucfirst(substr( $field->name, 0, strlen($field->name)-3 ));
		if ( class_exists($class) )
			$relatedClass = $class;
	}

	// are there models to fetch?
	if ( $relatedClass )
		eval( "\$models = $relatedClass::fetchAll();" );

	return $models;

}

{/php}

{if $modelId}
	{assign var="editType" value="Edit"}
{else}
	{assign var="editType" value="Create"}
{/if}

{include file="include/header.tpl" title="`$editType` `$modelClass`"}

{show_errors text="error saving..."}

{form url={ action="modelSave" smutty_modelClass=$modelClass smutty_modelId=$modelId } }

	<fieldset>

	{foreach item="field" from=$fields}

		{php}
			$field = $this->get_template_vars('field');
			$class = strtolower( $this->get_template_vars('modelClass') );
			$name = Smutty_Smarty::getFieldName( "$class.$field->name" );
			$this->assign( 'fieldName', $name );
		{/php}
		{assign var="fieldProp" value=$field->name}
		{assign var="labelClass" value=""}

		{if !$field->nullable}
			{assign var="labelClass" value="required"}
		{/if}

		{php}
			$model = $this->get_template_vars( 'model' );
			$field = $this->get_template_vars( 'field' );
			$name = $field->name;
			$this->assign( 'related', getRelatedData($model,$field) );
			$this->assign( 'fieldValue', $model->$name );
		{/php}

		{if is_array($related)}
			{select name=$fieldName from=$related label=$fieldProp
				selected=$fieldValue labelClass=$labelClass}

		{elseif $fieldName == 'id'}
			{* IGNORE ID FIELD *}

		{elseif preg_match('/^date/',$field->type)}
			{datefields name=$fieldName label=$fieldProp
				value=$model->$fieldProp class="datefield" labelClass=$labelClass}

		{elseif $field->type == 'text'}
			{textarea name=$fieldName label=$fieldProp
				value=$model->$fieldProp labelClass=$labelClass}

		{else}
			{field name=$fieldName label=$fieldProp
				value=$model->$fieldProp labelClass=$labelClass}
		{/if}

	{/foreach}

	{if $model->id}
		{assign var="submitText" value="Save Changes"}
	{else}
		{assign var="submitText" value="Create Record"}
	{/if}
	{submit text=$submitText}

	</fieldset>

{form_end}

{include file="include/footer.tpl"}
