<html>
<head>
<title>Smutty{if $title}: {$title|escape}{else}Smutty{/if}</title>

<link rel="Shortcut Icon" href="{url controller="smutty"
	action="resource" folder="images" file="smutty.ico" }" />

<link rel="stylesheet" type="text/css"
	href="{url controller="smutty" action="resource"
		folder="css" file="nonzero.css" }" />
<link rel="stylesheet" type="text/css"
	href="{url controller="smutty" action="resource"
		folder="css" file="infected.css" }" />
<link rel="stylesheet" type="text/css"
	href="{url controller="smutty" action="resource"
		folder="css" file="default.css" }" />

</head>

<body>

<div id="header">

	<div id="header_inner" class="fixed">

		{php}
		$title = $this->get_template_vars( 'title' );
		$parts = explode( ' ', $title );
		$desc = implode( '', array_slice($parts,1) );
		$this->assign( 'title', $parts[1]
			? "$parts[0]<span>" . trim(preg_replace('/_(.)/','$1',$desc)) . "</span>"
			: $parts[0]
		);
		{/php}

		<div id="logo">
			<h1>{if $title}{$title}{else}<span>smutty</span>MODELS{/if}</h1>
			<h2>{link text="smutty manager"}</h2>
		</div>

		<div id="menu">
			<ul>

				{if !$noMenu}
					{if $modelClass}
						<li>{link url={ action="modelBrowse" smutty_modelClass=$modelClass } text="Browse All" }</li>
						<li>{link url={ action="modelEdit" smutty_modelClass=$modelClass } text="Add New" }</li>
					{/if}
					<li>{link url={ action="models" } text="All Models" }</li>
					<li>{link url={ action="tests" } text="Tests" }</li>
				{/if}

				{if $smutty->session->user}
					<li>{link url={ action="logout" } class="active" }</li>
				{else}
					<li>{link url={ action="login" } class="active" }</li>
				{/if}
			</ul>

		</div>

	</div>

</div>

<div id="main">

	<div id="main_inner" class="fluid">

		<div id="primaryContent_columnless">

