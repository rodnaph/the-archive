<?php /* Smarty version 2.6.16, created on 2009-06-28 19:53:12
         compiled from wiki/index.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'escape', 'wiki/index.tpl', 4, false),array('modifier', 'wikitext', 'wiki/index.tpl', 6, false),array('modifier', 'date_format', 'wiki/index.tpl', 21, false),array('modifier', 'nl2br', 'wiki/index.tpl', 22, false),array('function', 'link', 'wiki/index.tpl', 11, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => ($this->_tpl_vars['page']->name))));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<h2><?php echo ((is_array($_tmp=$this->_tpl_vars['page']->name)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
</h2>

<p><?php echo ((is_array($_tmp=$this->_tpl_vars['page']->body)) ? $this->_run_mod_handler('wikitext', true, $_tmp) : smarty_modifier_wikitext($_tmp)); ?>
</p>

<p>
	<?php if ($this->_tpl_vars['smutty']->user || ( $this->_tpl_vars['page']->name != 'MainPage' )): ?><b>Links:</b><?php endif; ?>
	<?php if ($this->_tpl_vars['smutty']->user): ?>
		<?php echo smarty_function_link(array('url' => "action,edit,name,".($this->_tpl_vars['page']->name),'text' => 'Edit this page'), $this);?>

	<?php endif; ?>
	<?php if ($this->_tpl_vars['page']->name != 'MainPage'): ?>
		<?php if ($this->_tpl_vars['smutty']->user): ?>&middot;<?php endif; ?>
		<?php echo smarty_function_link(array('url' => "action,comment,name,".($this->_tpl_vars['page']->name),'text' => 'Post a comment'), $this);?>

	<?php endif; ?>
</p>

<?php if ($this->_tpl_vars['page']->comments): ?>
	<?php $_from = $this->_tpl_vars['page']->comments; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['comment']):
?>
		<h4>Posted by <?php echo ((is_array($_tmp=$this->_tpl_vars['comment']->name)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
 on <?php echo ((is_array($_tmp=$this->_tpl_vars['comment']->date_posted)) ? $this->_run_mod_handler('date_format', true, $_tmp, "%b %e") : smarty_modifier_date_format($_tmp, "%b %e")); ?>
</h4>
		<p style="border:1px #ddd solid;background-color:#eee;padding:5px 10px 5px 10px;"><?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['comment']->body)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)))) ? $this->_run_mod_handler('nl2br', true, $_tmp) : smarty_modifier_nl2br($_tmp)); ?>
</p>
	<?php endforeach; endif; unset($_from);  endif; ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/sidebar.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>