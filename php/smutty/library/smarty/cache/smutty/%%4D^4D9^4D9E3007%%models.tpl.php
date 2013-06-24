<?php /* Smarty version 2.6.16, created on 2007-06-09 16:28:58
         compiled from smutty/models.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', 'smutty/models.tpl', 6, false),array('modifier', 'pluralize', 'smutty/models.tpl', 6, false),array('modifier', 'plural', 'smutty/models.tpl', 7, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => 'Your Models')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $_from = $this->_tpl_vars['models']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['model'] => $this->_tpl_vars['total']):
?>
	<h3 class="link">
		<?php echo smarty_function_link(array('url' => "action,modelBrowse,smutty_modelClass,".($this->_tpl_vars['model']),'text' => ((is_array($_tmp=$this->_tpl_vars['model'])) ? $this->_run_mod_handler('pluralize', true, $_tmp) : smarty_modifier_pluralize($_tmp))), $this);?>

		<span style="font-size:0.3em;font-weight:normal;">(<?php echo ((is_array($_tmp=$this->_tpl_vars['total'])) ? $this->_run_mod_handler('plural', true, $_tmp, 'record') : smarty_modifier_plural($_tmp, 'record')); ?>
)</span>
	</h3>
<?php endforeach; else: ?>
	<h3>No Models Found</h3>
	<p>Looks like you haven't created any models yet! If you need some
	help you can read the tutorial on the wiki to find out
	<a href="http://smutty.pu-gh.com/wiki/ClassSmutty_Model">about models</a>,
	and how <a href="http://smutty.pu-gh.com/wiki/SmuttySmut">use <b>smut</b> to create them</a>.</p>
<?php endif; unset($_from); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>