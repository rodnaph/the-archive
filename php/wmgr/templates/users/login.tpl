
{include file="include/header.tpl" title="Login"}

<h2><img src="../images/22x22/login.png" /> Please log in...</h2>

<p>Before you can access the Work Manager you need to log in.  To do this just
enter your username and password into the form below and then click the login
button at the bottom of the page.</p>

<p>If you don't have a user account you can
<a href="register.php">create one here</a>.<p>

<form method="post" action="login.php">

	<fieldset>

		<input type="hidden" name="action" value="login" />
		<input type="hidden" name="return" value="{$smarty.get.return|escape}" />

		<label for="user">User:</label>
		<input type="text" name="user" id="User" />

		<label for="pass">Password:</label>
		<input type="password" name="pass" />

		<input type="submit" value="Login" />

	</fieldset>

</form>

<script type="text/javascript">
// set focus to the user name field
document.getElementById('User').focus();
</script>

{include file="include/footer.tpl"}
