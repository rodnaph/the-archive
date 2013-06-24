<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
<title>My Travel Journal{if $title} - {$title|escape}{/if}</title>

<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>

<style type="text/css" media="all">@import "{$smutty->baseUrl}/css/style.css";</style>

{if $ajax}{ajax_libs}{/if}

</head>

<body>

<div class="content">

	<div class="toph"></div>

	<div class="right">
		<div class="title">ROD'S BLOG</div>
		<div class="nav">

		<h1>Navigation</h1>
		<ul>
			<li>{link url={ controller="entry" } text="Home" }</li>
			<li>{link url={ controller="entry" action="search" } }</li>
			<li>{link url={ controller="entry" action="post" } }</li>
			<li>
			{if $smutty->session->user}
				{link url={ controller="user" action="logout" } }
			{else}
				{link url={ controller="user" action="login" } }
			{/if}
			</li>
		</ul>

		</div>

		{if $smutty->session->user}
		<h2>User Options</h2>
		<ul>
			<li>{link url={ controller="user" action="profile" } }</li>
			<li>{link url={ controller="user" action="prefs" } text="Preferences" }</li>
		</ul>
		{/if}

		<h2>Links</h2>
		<ul>
			<li><a href="http://www.flickr.com/photos/rod_naph/">Rods Photos</a></li>
			<li><a href="http://smutty.pu-gh.com">Smutty</a></li>
			<li><a href="http://korea.banoffeepie.com/">Korean Blogs</a></li>
		</ul>

		<hr />

		<div class="footer_text">
			Design: <a href="http://www.free-css-templates.com/" title="Free CSS Templates">David Herreman</a>
		</div>

	</div>

	<div class="center">
