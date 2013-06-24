<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Smutty - {if $title}{$title|escape}{else}MVC Framework{/if}</title>

<meta name="verify-v1" content="u0IY6dFN11p5H11KrmajHzqTpkPNrxu5HZgbXlDQptI=" />

<meta http-equiv="Content-Language" content="English" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

{rss model="page"}

<link rel="Shortcut Icon" href="{$smutty->baseUrl}/images/smutty.ico" />

<link rel="stylesheet" type="text/css" href="{$smutty->baseUrl}/css/style.css" media="screen" />

{if $enableAjax}
	{ajax_libs}
{/if}

</head>

<body>

<div id="wrap">

<div id="top"></div>

<div id="content">

<div class="header">
	<h1><img src="{$smutty->baseUrl}/images/logo.png" title="Smutty Logo" /> Smutty</h1>
	<h2>MVC Framework</h2>
</div>

<div class="breadcrumbs">
	{link url={ controller="wiki" } text="Home"} &middot;
	{link url={ controller="wiki" name="SmuttyDownloads" } text="Get Smutty"} &middot;
	{link url={ controller="demo" } text="View Demos"} &middot;
	{link url={ controller="wiki" name="SmuttyManual" } text="Read Manual"} &middot;
	{if $smutty->user}
		{link url={ controller="user" action="logout"} }
	{else}
		{link url={ controller="user" action="login" } }
	{/if}

</div>

<div class="middle">
