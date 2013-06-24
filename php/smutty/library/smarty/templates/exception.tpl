
{include file="include/header.tpl" title="Smutty Exception" noMenu="true"}

{php}
$server = Smutty_Data::getServerData();
$this->assign( 'urlParts', array_slice(split('/',$server->string('REQUEST_URI')),1) );
{/php}

<h2>
{assign var="urlFull" value=""}
{foreach item="part" from=$urlParts}
	{assign var="urlFull" value="$urlFull/$part"}
	/ <a href="{$urlFull}">{$part}</a>
{/foreach}
</h2>

<h3><b>Burp!</b> An error has occurred, the following message was reported:</h3>

<p style="font-size:1.4em;"><b>{$message|escape}</b></p>

<p style="font-size:1.2em;">
You may be able to <a href="http://smutty.pu-gh.com/wiki/{$wikiHelp|escape}">find help on the wiki</a>,
{if substr($wikiHelp,0,5) eq "Class"}
	in <a href="http://smutty.pu-gh.com/api/smutty/{$wikiHelp|substr:5|lower}.html">the api documentation</a>
{/if}
or you can <a href="javascript:;" onclick="javascript:document.getElementById('StackTrace').style.display='block';">view the stack trace</a>.
</p>

<div id="StackTrace" style="display:none;">

<h3>Stack Trace</h3>

{foreach item="crate" from=$stack}
<p>
	<h4>{php}$v = $this->get_template_vars('crate');echo $v['function'];{/php}()</h4>
	{foreach key="name" item="value" from=$crate}
		{if $name == "args"}
			<b>Arguments:</b>
			<ul>
			{foreach item="arg" from=$value}
				<li>{$arg}</li>
			{/foreach}
			</ul>
		{elseif $name != "function"}
			<b>{$name}:</b> {$value}<br />
		{/if}
	{/foreach}
</p>
{/foreach}

</div>

{include file="include/footer.tpl"}
