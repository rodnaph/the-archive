
<html>
<head>
<title>wmgr{if $title} - {$title}{/if}</title>

<link rel="stylesheet" href="{$URL_BASE}/css/default.css" type="text/css" />

<script type="text/javascript" src="{$URL_BASE}/javascript/shared.js"></script>
<script type="text/javascript">

var URL_BASE = '{$URL_BASE|escape}';
var user = {if $user}new User( '{$user->id}', '{$user->name|escape}' ){else}null{/if};

</script>

</head>

<body{if $section} id="{$section}Section"{/if}>
