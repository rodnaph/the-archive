
{include file="include/header-simple.tpl"}

<div id="TitleWrap">

	<div id="SiteDescription">A Web Based Work Application</div>

	<h1>WorkManager v0.0.1</h1>

	<div id="NavWrap">
		{if $user}<b><a href="{$URL_BASE}/users/dashboard.php"><img src="{$URL_BASE}/images/12x12/dash.png" />{$user->name|escape}</a></b>{/if}
	</div>
	<script type="text/javascript" src="{$URL_BASE}/javascript/menu.js"></script>

</div>

<div id="MainWrap">

