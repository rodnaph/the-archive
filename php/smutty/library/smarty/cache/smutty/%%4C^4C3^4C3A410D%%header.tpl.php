<?php /* Smarty version 2.6.16, created on 2007-06-09 07:26:01
         compiled from include/header.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'escape', 'include/header.tpl', 3, false),array('function', 'url', 'include/header.tpl', 5, false),array('function', 'link', 'include/header.tpl', 38, false),)), $this); ?>
<html>
<head>
<title>Smutty<?php if ($this->_tpl_vars['title']): ?>: <?php echo ((is_array($_tmp=$this->_tpl_vars['title'])) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp));  else: ?>Smutty<?php endif; ?></title>

<link rel="Shortcut Icon" href="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'images','file' => "smutty.ico"), $this);?>
" />

<link rel="stylesheet" type="text/css"
	href="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'css','file' => "nonzero.css"), $this);?>
" />
<link rel="stylesheet" type="text/css"
	href="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'css','file' => "infected.css"), $this);?>
" />
<link rel="stylesheet" type="text/css"
	href="<?php echo smarty_function_url(array('controller' => 'smutty','action' => 'resource','folder' => 'css','file' => "default.css"), $this);?>
" />

</head>

<body>

<div id="header">

	<div id="header_inner" class="fixed">

		<?php 
		$title = $this->get_template_vars( 'title' );
		$parts = explode( ' ', $title );
		$desc = implode( '', array_slice($parts,1) );
		$this->assign( 'title', $parts[1]
			? "$parts[0]<span>" . trim(preg_replace('/_(.)/','$1',$desc)) . "</span>"
			: $parts[0]
		);
		 ?>

		<div id="logo">
			<h1><?php if ($this->_tpl_vars['title']):  echo $this->_tpl_vars['title'];  else: ?><span>smutty</span>MODELS<?php endif; ?></h1>
			<h2><?php echo smarty_function_link(array('text' => 'smutty manager'), $this);?>
</h2>
		</div>

		<div id="menu">
			<ul>

				<?php if (! $this->_tpl_vars['noMenu']): ?>
					<?php if ($this->_tpl_vars['modelClass']): ?>
						<li><?php echo smarty_function_link(array('url' => "action,modelBrowse,smutty_modelClass,".($this->_tpl_vars['modelClass']),'text' => 'Browse All'), $this);?>
</li>
						<li><?php echo smarty_function_link(array('url' => "action,modelEdit,smutty_modelClass,".($this->_tpl_vars['modelClass']),'text' => 'Add New'), $this);?>
</li>
					<?php endif; ?>
					<li><?php echo smarty_function_link(array('url' => "action,models",'text' => 'All Models'), $this);?>
</li>
					<li><?php echo smarty_function_link(array('url' => "action,tests",'text' => 'Tests'), $this);?>
</li>
				<?php endif; ?>

				<?php if ($this->_tpl_vars['smutty']->session->user): ?>
					<li><?php echo smarty_function_link(array('url' => "action,logout",'class' => 'active'), $this);?>
</li>
				<?php else: ?>
					<li><?php echo smarty_function_link(array('url' => "action,login",'class' => 'active'), $this);?>
</li>
				<?php endif; ?>
			</ul>

		</div>

	</div>

</div>

<div id="main">

	<div id="main_inner" class="fluid">

		<div id="primaryContent_columnless">
