<?php /* Smarty version 2.6.16, created on 2007-06-09 07:26:01
         compiled from exception.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'escape', 'exception.tpl', 19, false),array('modifier', 'substr', 'exception.tpl', 24, false),array('modifier', 'lower', 'exception.tpl', 24, false),)), $this); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/header.tpl", 'smarty_include_vars' => array('title' => 'Smutty Exception','noMenu' => 'true')));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<?php 
$server = Smutty_Data::getServerData();
$this->assign( 'urlParts', array_slice(split('/',$server->string('REQUEST_URI')),1) );
 ?>

<h2>
<?php $this->assign('urlFull', "");  $_from = $this->_tpl_vars['urlParts']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['part']):
?>
	<?php $this->assign('urlFull', ($this->_tpl_vars['urlFull'])."/".($this->_tpl_vars['part'])); ?>
	/ <a href="<?php echo $this->_tpl_vars['urlFull']; ?>
"><?php echo $this->_tpl_vars['part']; ?>
</a>
<?php endforeach; endif; unset($_from); ?>
</h2>

<h3><b>Burp!</b> An error has occurred, the following message was reported:</h3>

<p style="font-size:1.4em;"><b><?php echo ((is_array($_tmp=$this->_tpl_vars['message'])) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
</b></p>

<p style="font-size:1.2em;">
You may be able to <a href="http://smutty.pu-gh.com/wiki/<?php echo ((is_array($_tmp=$this->_tpl_vars['wikiHelp'])) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp)); ?>
">find help on the wiki</a>,
<?php if (substr ( $this->_tpl_vars['wikiHelp'] , 0 , 5 ) == 'Class'): ?>
	in <a href="http://smutty.pu-gh.com/api/smutty/<?php echo ((is_array($_tmp=((is_array($_tmp=$this->_tpl_vars['wikiHelp'])) ? $this->_run_mod_handler('substr', true, $_tmp, 5) : substr($_tmp, 5)))) ? $this->_run_mod_handler('lower', true, $_tmp) : smarty_modifier_lower($_tmp)); ?>
.html">the api documentation</a>
<?php endif; ?>
or you can <a href="javascript:;" onclick="javascript:document.getElementById('StackTrace').style.display='block';">view the stack trace</a>.
</p>

<div id="StackTrace" style="display:none;">

<h3>Stack Trace</h3>

<?php $_from = $this->_tpl_vars['stack']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['crate']):
?>
<p>
	<h4><?php $v = $this->get_template_vars('crate');echo $v['function']; ?>()</h4>
	<?php $_from = $this->_tpl_vars['crate']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['name'] => $this->_tpl_vars['value']):
?>
		<?php if ($this->_tpl_vars['name'] == 'args'): ?>
			<b>Arguments:</b>
			<ul>
			<?php $_from = $this->_tpl_vars['value']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['arg']):
?>
				<li><?php echo $this->_tpl_vars['arg']; ?>
</li>
			<?php endforeach; endif; unset($_from); ?>
			</ul>
		<?php elseif ($this->_tpl_vars['name'] != 'function'): ?>
			<b><?php echo $this->_tpl_vars['name']; ?>
:</b> <?php echo $this->_tpl_vars['value']; ?>
<br />
		<?php endif; ?>
	<?php endforeach; endif; unset($_from); ?>
</p>
<?php endforeach; endif; unset($_from); ?>

</div>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "include/footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>