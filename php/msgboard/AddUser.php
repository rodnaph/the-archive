<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	$name = htmlspecialchars(trim($_POST['name']));

	/**
	 *  checks the submission for errors, returns a string describing
	 *  the error if one was found, FALSE if all ok.  NB! assumes the
	 *  database connection is open.
	 *
	 */

	function errorCheck() {

		global $name;

		// required fields
		$required = array( 'name', 'pass1', 'email' );
		while ( $field = array_pop($required) )
			if ( $_POST[$field] == '' ) return 'you missed a required field';

		// passwords
		if ( $_POST['pass1'] != $_POST['pass2'] )
			return "your passwords don't match";

		// check name doesn't exist
		$sql = " select id from users where name like '$name' ";
		$res = mysql_query( $sql );
		if ( @mysql_fetch_assoc($res) )
			return 'that username is already taken';

		// check color is ok
		$sql = " select id from colors where id = " . $_POST['color'];
		$res = mysql_query($sql);
		if ( !@mysql_fetch_assoc($res) )
			return 'the color is not valid';

		return false;

	}

	// will need the connection whatever happens
	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	/**
	 *  trying to register a user
	 *
	 */

	if ( $_POST['action'] == 'add_user' ) {

		if ( $errorString = errorCheck() )
			reportError( $errorString,  " AddUser.php, name = $name, pass1 = $_POST[pass1], pass2 = $_POST[pass2], email = $_POST[email] " );

		else {

			$pass = mysql_escape_string($_POST['pass1']);
			$email = mysql_escape_string($_POST['email']);
			// $_POST[color] has been checked, so it's ok to just stick it in

			$sql = " insert into users ( name, pass, email, created, color ) " .
					 " values ( '$name', '$pass', '$email', NOW(), $_POST[color] ) ";
			mysql_query( $sql );
			
			?>

			<p id="MainTitle">:: registered</p>

			<p>
				[
					<a class="NavLink" href="index.php">home</a>
				]
			</p>

			<p>The username has been registered, you can now use it on the board.</p>

			<?php

		}

	}
	
	/**
	 *  just draw the page
	 *
	 */

	else {
?>

<p id="MainTitle">:: register</p>

<p>
	[
		<a class="NavLink" href="index.php">home</a>
	]
</p>

<p>
	To sign up just fill in the crapola...
</p>

<form method="post" action="AddUser.php">

	<div class="Hidden">
		<input type="hidden" name="action" value="add_user" />
	</div>

	<div>
		<span class="FormTitle">:: name</span><br />
		<input class="FormControl" type="text" name="name" size="50" maxlength="50" />
	</div>

	<div>
		<span class="FormTitle">:: password (twice)</span><br />
		<input class="FormControl" type="password" name="pass1" size="20" maxlength="30" />
		&nbsp; <span class="FormTitle">and</span> &nbsp;
		<input class="FormControl" type="password" name="pass2" size="20" maxlength="30" />
	</div>

	<div>
		<span class="FormTitle">:: email</span><br />
		<input class="FormControl" type="text" name="email" size="50" maxlength="100" />
	</div>

	<div>
		<span class="FormTitle">:: color</span><br />
		<select name="color" class="FormControl" onchange="this.style.color=this.options[this.selectedIndex].style.color;">
		<?php

			$sql = " select " .
					 	" id as color_id, description as color_desc, hex_value as color_hex " .
					 " from colors " .
					 " order by description ";
			$res = mysql_query( $sql );

			while ( $row = mysql_fetch_assoc($res) )
				echo '<option value="' . $row['color_id'] . '" style="color: #' . $row['color_hex'] . ';">' . $row['color_desc'] . '</option>';

		?>
		</select>
	</div>

	<p>
		<input class="FormControl" type="submit" value="Sign Up" />
	</p>

</form>

<?php
	}

	include 'Data/Inc/Footer.inc.php';

?>
