<?php /* Smarty version 2.6.16, created on 2007-06-09 16:29:00
         compiled from smutty/modelBrowse.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'pluralize', 'smutty/modelBrowse.tpl', 2, false),array('modifier', 'escape', 'smutty/modelBrowse.tpl', 26, false),array('modifier', 'truncate', 'smutty/modelBrowse.tpl', 56, false),array('function', 'paginate', 'smutty/modelBrowse.tpl', 11, false),array('function', 'url', 'smutty/modelBrowse.tpl', 30, false),array('function', 'link', 'smutty/modelBrowse.tpl', 54, false),)), $this); ?>

<?php $this->assign('modelPlural', ((is_array($_tmp=$this->_tpl_vars['modelClass'])) ? $this->_run_mod_handler('pluralize', true, $_tmp) : smarty_modifier_pluralize($_tmp)));  $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => "Browse ".($this->_tpl_vars['modelPlural']))));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "smutty/modelRelated.tpl", 'smarty_include_vars' => array('model' => "")));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php if ($this->_tpl_vars['total'] > $this->_tpl_vars['perPage']): ?>
<p>
<b>Pages:</b>

<?php echo smarty_function_paginate(array('url' => "action,modelBrowse,smutty_modelClass,".($this->_tpl_vars['modelClass']),'total' => $this->_tpl_vars['total'],'start' => $this->_tpl_vars['start'],'perPage' => '10'), $this);?>


</p>
<?php endif; ?>

<table>
	<tr>
		<th class="link"></th>
		<?php $_from = $this->_tpl_vars['fields']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['field']):
?>
			<th class="dataHeader">

				<?php echo ((is_array($_tmp=$this->_tpl_vars['field']->name)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>


				<a href="?order=<?php echo ((is_array($_tmp=$this->_tpl_vars['field']->name)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
&amp;dir=asc"
					title="Ascending Order"><img
					src="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'images','file' => "tinyarrow-up.png"), $this);?>
" /></a><a
				title="Descending Order" href="?order=<?php echo ((is_array($_tmp=$this->_tpl_vars['field']->name)) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
&amp;dir=desc""><img
					src="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'images','file' => "tinyarrow-down.png"), $this);?>
" /></a>

			</th>
		<?php endforeach; endif; unset($_from); ?>
	</tr>
	<?php $_from = $this->_tpl_vars['models']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['model']):
?>
	<tr>
		<td class="link">
			<a href="<?php echo smarty_function_url(array('action' => 'modelShow','smutty_modelClass' => $this->_tpl_vars['modelClass'],'smutty_modelId' => $this->_tpl_vars['model']->id), $this);?>
" title="View Record"><img
				src="<?php echo smarty_function_url(array('action' => 'resource','folder' => 'icons','file' => "show.png"), $this);?>
" /></a>
			<a href="<?php echo smarty_function_url(array('action' => 'modelEdit','smutty_modelClass' => $this->_tpl_vars['modelClass'],'smutty_modelId' => $this->_tpl_vars['model']->id), $this);?>
" title="Edit Record"><img
				src="<?php echo smarty_function_url(array('action' => 'resource','folder' => 'icons','file' => "edit.png"), $this);?>
" /></a>
			<a href="<?php echo smarty_function_url(array('action' => 'modelDelete','smutty_modelClass' => $this->_tpl_vars['modelClass'],'smutty_modelId' => $this->_tpl_vars['model']->id), $this);?>
" title="Delete Record"><img
				src="<?php echo smarty_function_url(array('action' => 'resource','folder' => 'icons','file' => "delete.png"), $this);?>
" /></a>
		</td>
		<?php $_from = $this->_tpl_vars['fields']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['field']):
?>
			<?php $this->assign('name', $this->_tpl_vars['field']->name); ?>
			<?php $this->assign('value', $this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['name']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")}); ?>
			<td>
				<?php if (is_object ( $this->_tpl_vars['value'] )): ?>
					<?php echo smarty_function_link(array('url' => "action,modelShow,smutty_modelClass,".($this->_tpl_vars['name']).",smutty_modelId,".($this->_tpl_vars['value']->id),'text' => $this->_tpl_vars['value']->name), $this);?>

				<?php else: ?>
					<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['model']->{(($_var=$this->_tpl_vars['name']) && substr($_var,0,2)!='__') ? $_var : $this->trigger_error("cannot access property \"$_var\"")})) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)))) ? $this->_run_mod_handler('truncate', true, $_tmp, '30') : smarty_modifier_truncate($_tmp, '30')); ?>

				<?php endif; ?>
			</td>
		<?php endforeach; endif; unset($_from); ?>
	</tr>
	<?php endforeach; else: ?>
	<tr>
		<?php $this->assign('colCount',sizeof($this->get_template_vars('fields'))+1); ?>
		<td colspan="<?php echo $this->_tpl_vars['colCount']; ?>
">
			No records found...
		</td>
	</tr>
	<?php endif; unset($_from); ?>
</table>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>