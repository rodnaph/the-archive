
{include file="include/header.tpl" title="Login"}

<h2>Logging In</h2>

<p>To log in just whack your username and password into the
fields below and hit the <b>login</b> button.</p>

{form url={ action="login" } }

	<fieldset>

	{field name="myUsername" label="Username:"}

	{password name="myPassword" label="Password:"}

	{submit text="Login"}

	</fieldset>

{form_end}

<div class="clearer"></div>

{include file="include/footer.tpl"}
