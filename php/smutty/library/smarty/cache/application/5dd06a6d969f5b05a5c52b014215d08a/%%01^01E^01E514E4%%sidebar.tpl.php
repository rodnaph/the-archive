<?php /* Smarty version 2.6.16, created on 2009-06-28 19:53:12
         compiled from include/sidebar.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', 'include/sidebar.tpl', 21, false),)), $this); ?>

</div>

<div class="right">

<script type="text/javascript"><!--
google_ad_client = "pub-3203423048497860";
/* smutty - top nav links */
google_ad_slot = "0682753067";
google_ad_width = 160;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

<h2>Useful Pages</h2>

<ul>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyInstall",'text' => 'Installing'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,ClassSmutty_Controller",'text' => 'Controllers'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,ClassSmutty_Model",'text' => 'Models'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyViews",'text' => 'Views'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyConfig",'text' => 'Configuration'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyAjax",'text' => 'Ajax Support'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyRoutes",'text' => 'Custom Routes'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,wiki,name,SmuttyTests",'text' => 'Unit Testing'), $this);?>
</li>
<li><?php echo smarty_function_link(array('url' => "controller,code",'text' => 'Reference'), $this);?>
</li>
<li><a href="<?php echo $this->_tpl_vars['smutty']->baseUrl; ?>
/api/index.html">API Docs</a></li>
</ul>

<h2>Links</h2>

<ul>
	<li><a href="http://code.google.com/p/smutty">Google Code - Smutty</a></li>
	<li><a href="http://smarty.php.net">Smarty</a></li>
	<li><a href="http://www.php.net">PHP</a></li>
	<li><a href="http://httpd.apache.org">Apache</a></li>
	<li><a href="http://www.kubuntu.org">Kubuntu</a></li>
</ul>