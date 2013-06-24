
{include file="include/header.tpl" title="Login"}

<h2>Login</h2>

<form method="post" action="{url action="login"}">

	<fieldset>

		<label>Name:</label>
		<input type="text" name="username" />

		<label>Password:</label>
		<input type="password" name="password" />

		<input type="submit" value="Login" />

	</fieldset>

</form>

{include file="include/sidebar.tpl"}

{include file="include/footer.tpl"}
