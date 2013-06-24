<?php /* Smarty version 2.6.16, created on 2009-06-28 19:53:12
         compiled from include/header.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'escape', 'include/header.tpl', 4, false),array('function', 'rss', 'include/header.tpl', 11, false),array('function', 'ajax_libs', 'include/header.tpl', 18, false),array('function', 'link', 'include/header.tpl', 37, false),)), $this); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Smutty - <?php if ($this->_tpl_vars['title']):  echo ((is_array($_tmp=$this->_tpl_vars['title'])) ? $this->_run_mod_handler('escape', true, $_tmp) : smarty_modifier_escape($_tmp));  else: ?>MVC Framework<?php endif; ?></title>

<meta name="verify-v1" content="u0IY6dFN11p5H11KrmajHzqTpkPNrxu5HZgbXlDQptI=" />

<meta http-equiv="Content-Language" content="English" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<?php echo smarty_function_rss(array('model' => 'page'), $this);?>


<link rel="Shortcut Icon" href="<?php echo $this->_tpl_vars['smutty']->baseUrl; ?>
/images/smutty.ico" />

<link rel="stylesheet" type="text/css" href="<?php echo $this->_tpl_vars['smutty']->baseUrl; ?>
/css/style.css" media="screen" />

<?php if ($this->_tpl_vars['enableAjax']): ?>
	<?php echo smarty_function_ajax_libs(array(), $this);?>

<?php endif; ?>

</head>

<body>

<div id="wrap">

<div id="top"></div>

<div id="content">

<div class="header">
	<h1><img src="<?php echo $this->_tpl_vars['smutty']->baseUrl; ?>
/images/logo.png" title="Smutty Logo" /> Smutty</h1>
	<h2>MVC Framework</h2>
</div>

<div class="breadcrumbs">
	<?php echo smarty_function_link(array('url' => "controller,wiki",'text' => 'Home'), $this);?>
 &middot;
	<?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyDownloads",'text' => 'Get Smutty'), $this);?>
 &middot;
	<?php echo smarty_function_link(array('url' => "controller,demo",'text' => 'View Demos'), $this);?>
 &middot;
	<?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyManual",'text' => 'Read Manual'), $this);?>
 &middot;
	<?php if ($this->_tpl_vars['smutty']->user): ?>
		<?php echo smarty_function_link(array('url' => "controller,user,action,logout"), $this);?>

	<?php else: ?>
		<?php echo smarty_function_link(array('url' => "controller,user,action,login"), $this);?>

	<?php endif; ?>

</div>

<div class="middle">