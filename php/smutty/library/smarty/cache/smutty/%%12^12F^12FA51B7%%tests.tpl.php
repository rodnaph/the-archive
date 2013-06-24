<?php /* Smarty version 2.6.16, created on 2007-06-09 16:29:24
         compiled from smutty/tests.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', 'smutty/tests.tpl', 11, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => 'Unit Tests')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<h3>Test Cases</h3>

<p>Below are listed the test cases you have created for your application.  To
run a particular test case just click on it.</p>

<ul>
<?php $_from = $this->_tpl_vars['tests']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['test']):
?>
	<li><?php echo smarty_function_link(array('url' => "action,testRun,file,".($this->_tpl_vars['test']),'text' => $this->_tpl_vars['test']), $this);?>
</li>
<?php endforeach; endif; unset($_from); ?>
</ul>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>