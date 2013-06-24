<?php /* Smarty version 2.6.16, created on 2007-06-09 16:29:00
         compiled from smutty/modelRelated.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', 'smutty/modelRelated.tpl', 6, false),)), $this); ?>

<?php if ($this->_tpl_vars['relatedModels']): ?>
<div><b>Related<span style="font-weight:normal;">Models</span>:</b>

	<?php $this->assign('first', '1'); ?>
	<?php $_from = $this->_tpl_vars['relatedModels']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['related'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['related']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['model']):
        $this->_foreach['related']['iteration']++;
 if (($this->_foreach['related']['iteration'] == $this->_foreach['related']['total']) && ! ($this->_foreach['related']['iteration'] <= 1)): ?> and <?php elseif (! ($this->_foreach['related']['iteration'] <= 1)): ?>, <?php endif;  echo smarty_function_link(array('url' => "action,modelBrowse,smutty_modelClass,".($this->_tpl_vars['model']),'text' => $this->_tpl_vars['model']), $this); endforeach; endif; unset($_from); ?>
</div>
<br />
<?php endif; ?>