<?php /* Smarty version 2.6.16, created on 2007-06-19 07:46:42
         compiled from smutty/modelDelete.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'form', 'smutty/modelDelete.tpl', 8, false),array('function', 'hidden', 'smutty/modelDelete.tpl', 10, false),array('function', 'submit', 'smutty/modelDelete.tpl', 12, false),array('function', 'form_end', 'smutty/modelDelete.tpl', 14, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => 'Delete Model')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<p>Are you <b>ABSOLUTELY</b> sure you want to delete this record?  There
is no undo, this is unrecoverable.  If you're really sure click the
delete button below.</p>

<?php echo smarty_function_form(array('url' => "action,modelDelete,smutty_modelClass,".($this->_tpl_vars['modelClass']).",smutty_modelId,".($this->_tpl_vars['modelId'])), $this);?>


	<?php echo smarty_function_hidden(array('name' => 'confirmCode','value' => $this->_tpl_vars['confirmCode']), $this);?>


	<?php echo smarty_function_submit(array('text' => "I'm sure, delete the record"), $this);?>


<?php echo smarty_function_form_end(array(), $this);?>


<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>