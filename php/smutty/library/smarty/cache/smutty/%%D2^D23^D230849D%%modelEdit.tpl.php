<?php /* Smarty version 2.6.16, created on 2007-06-13 00:29:55
         compiled from smutty/modelEdit.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'show_errors', 'smutty/modelEdit.tpl', 62, false),array('function', 'form', 'smutty/modelEdit.tpl', 64, false),array('function', 'select', 'smutty/modelEdit.tpl', 92, false),array('function', 'datefields', 'smutty/modelEdit.tpl', 99, false),array('function', 'textarea', 'smutty/modelEdit.tpl', 103, false),array('function', 'field', 'smutty/modelEdit.tpl', 107, false),array('function', 'submit', 'smutty/modelEdit.tpl', 118, false),array('function', 'form_end', 'smutty/modelEdit.tpl', 122, false),)), $this); ?>
<?php 

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

 ?>

<?php if ($this->_tpl_vars['modelId']): ?>
	<?php $this->assign('editType', 'Edit');  else: ?>
	<?php $this->assign('editType', 'Create');  endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => ($this->_tpl_vars['editType'])." ".($this->_tpl_vars['modelClass']))));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php echo smarty_function_show_errors(array('text' => "error saving..."), $this);?>


<?php echo smarty_function_form(array('url' => "action,modelSave,smutty_modelClass,".($this->_tpl_vars['modelClass']).",smutty_modelId,".($this->_tpl_vars['modelId'])), $this);?>


	<fieldset>

	<?php $_from = $this->_tpl_vars['fields']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['field']):
?>

		<?php 
			$field = $this->get_template_vars('field');
			$class = strtolower( $this->get_template_vars('modelClass') );
			$name = Smutty_Smarty::getFieldName( "$class.$field->name" );
			$this->assign( 'fieldName', $name );
		 ?>
		<?php $this->assign('fieldProp', $this->_tpl_vars['field']->name); ?>
		<?php $this->assign('labelClass', ""); ?>

		<?php if (! $this->_tpl_vars['field']->nullable): ?>
			<?php $this->assign('labelClass', 'required'); ?>
		<?php endif; ?>

		<?php 
			$model = $this->get_template_vars( 'model' );
			$field = $this->get_template_vars( 'field' );
			$name = $field->name;
			$this->assign( 'related', getRelatedData($model,$field) );
			$this->assign( 'fieldValue', $model->$name );
		 ?>

		<?php if (is_array ( $this->_tpl_vars['related'] )): ?>
			<?php echo smarty_function_select(array('name' => $this->_tpl_vars['fieldName'],'from' => $this->_tpl_vars['related'],'label' => $this->_tpl_vars['fieldProp'],'selected' => $this->_tpl_vars['fieldValue'],'labelClass' => $this->_tpl_vars['labelClass']), $this);?>


		<?php elseif ($this->_tpl_vars['fieldName'] == 'id'): ?>
			
		<?php elseif (preg_match ( '/^date/' , $this->_tpl_vars['field']->type )): ?>
			<?php echo smarty_function_datefields(array('name' => $this->_tpl_vars['fieldName'],'label' => $this->_tpl_vars['fieldProp'],'value' => $this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['fieldProp']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")},'class' => 'datefield','labelClass' => $this->_tpl_vars['labelClass']), $this);?>


		<?php elseif ($this->_tpl_vars['field']->type == 'text'): ?>
			<?php echo smarty_function_textarea(array('name' => $this->_tpl_vars['fieldName'],'label' => $this->_tpl_vars['fieldProp'],'value' => $this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['fieldProp']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")},'labelClass' => $this->_tpl_vars['labelClass']), $this);?>


		<?php else: ?>
			<?php echo smarty_function_field(array('name' => $this->_tpl_vars['fieldName'],'label' => $this->_tpl_vars['fieldProp'],'value' => $this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['fieldProp']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")},'labelClass' => $this->_tpl_vars['labelClass']), $this);?>

		<?php endif; ?>

	<?php endforeach; endif; unset($_from); ?>

	<?php if ($this->_tpl_vars['model']->id): ?>
		<?php $this->assign('submitText', 'Save Changes'); ?>
	<?php else: ?>
		<?php $this->assign('submitText', 'Create Record'); ?>
	<?php endif; ?>
	<?php echo smarty_function_submit(array('text' => $this->_tpl_vars['submitText']), $this);?>


	</fieldset>

<?php echo smarty_function_form_end(array(), $this);?>


<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>