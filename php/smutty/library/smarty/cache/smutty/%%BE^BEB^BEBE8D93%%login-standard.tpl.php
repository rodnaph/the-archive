<?php /* Smarty version 2.6.16, created on 2007-06-09 16:28:46
         compiled from smutty/login-standard.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'form', 'smutty/login-standard.tpl', 4, false),array('function', 'field', 'smutty/login-standard.tpl', 6, false),array('function', 'password', 'smutty/login-standard.tpl', 8, false),array('function', 'submit', 'smutty/login-standard.tpl', 10, false),array('function', 'form_end', 'smutty/login-standard.tpl', 12, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => 'Smutty Login')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php echo smarty_function_form(array('url' => "action,login"), $this);?>


	<?php echo smarty_function_field(array('name' => $this->_tpl_vars['nameParam'],'label' => "Username:"), $this);?>


	<?php echo smarty_function_password(array('name' => $this->_tpl_vars['passParam'],'label' => "Password:"), $this);?>


	<?php echo smarty_function_submit(array('text' => 'Login'), $this);?>


<?php echo smarty_function_form_end(array(), $this);?>


<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>