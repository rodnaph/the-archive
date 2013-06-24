
{include file="include/header.tpl" title="Register"}

<h2><img src="../images/22x22/profile.png" /> Creating a new account</h2>

<p>Before you can use the Work Manager you will need to create an account so
that you can log in.  To do this just fill out the required information in the
form below and then click the submit button at the bottom of the page.  You'll
receive an email to confirm your address and activate your account, then you're
good to go!</p>

<p>If you already have a user account then you can
<a href="login.php">login here</a>.<p>

<form method="post" action="register.php">

	<fieldset>

		<input type="hidden" name="action" value="register" />

		<label for="user">User:</label>
		<input type="text" name="user" />

		<label for="pass">Password:</label>
		<input type="password" name="pass" />

		<label for="pass2">Retype password:</label>
		<input type="password" name="pass2" />

		<label for="email">Email:</label>
		<input type="text" name="email" />

		<input type="submit" value="Register" />

	</fieldset>

</form>

{include file="include/footer.tpl"}
