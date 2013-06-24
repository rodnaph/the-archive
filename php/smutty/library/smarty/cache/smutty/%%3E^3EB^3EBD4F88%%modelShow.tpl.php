<?php /* Smarty version 2.6.16, created on 2007-06-13 00:29:50
         compiled from smutty/modelShow.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'label', 'smutty/modelShow.tpl', 17, false),array('function', 'link', 'smutty/modelShow.tpl', 20, false),array('function', 'form', 'smutty/modelShow.tpl', 28, false),array('function', 'submit', 'smutty/modelShow.tpl', 29, false),array('function', 'form_end', 'smutty/modelShow.tpl', 30, false),array('modifier', 'escape', 'smutty/modelShow.tpl', 22, false),)), $this); ?>

<?php if ($this->_tpl_vars['model']->name): ?>
	<?php $this->assign('modelDesc', $this->_tpl_vars['model']->name);  else: ?>
	<?php $this->assign('modelDesc', $this->_tpl_vars['model']->id);  endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => ($this->_tpl_vars['modelClass'])." ".($this->_tpl_vars['modelDesc']))));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php if ($this->_tpl_vars['model']): ?>

<div class="data">

<?php $_from = $this->_tpl_vars['fields']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['field']):
?>
	<?php $this->assign('name', $this->_tpl_vars['field']->name); ?>
	<?php $this->assign('value', $this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['name']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")}); ?>
	<?php echo smarty_function_label(array('text' => $this->_tpl_vars['name']), $this);?>

		<div class="value">
		<?php if (is_object ( $this->_tpl_vars['value'] )): ?>
			<?php echo smarty_function_link(array('url' => "action,modelShow,smutty_modelClass,".($this->_tpl_vars['name']).",smutty_modelId,".($this->_tpl_vars['value']->id),'text' => $this->_tpl_vars['value']->name), $this);?>

		<?php else: ?>
			<?php echo ((is_array($_tmp=$this->_tpl_vars['value'])) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>

		<?php endif; ?>
		&nbsp;
		</div>
<?php endforeach; endif; unset($_from); ?>

<?php echo smarty_function_form(array('method' => 'get','url' => "action,modelEdit,smutty_modelClass,".($this->_tpl_vars['modelClass']).",smutty_modelId,".($this->_tpl_vars['modelId'])), $this);?>

	<?php echo smarty_function_submit(array('text' => 'Edit Record'), $this);?>

<?php echo smarty_function_form_end(array(), $this);?>


</div>

<div class="clearer"></div>

<?php else: ?>
<h3>Record Not Found</h3>
<p>The record you requested was not found.</p>
<?php endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>