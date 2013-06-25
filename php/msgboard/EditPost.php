<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  checks submission for errors, assumes db conn is open
	 *
	 */

	function errorCheck() {

		// check required fields
		$required = array( 'name', 'pass', 'subject', 'body' );
		while ( $field = array_pop($required) )
			if ( $_POST[$field] == '' ) return 'you missed a required field';

		// check user is ok to edit this post
		$sql = " select " .
				 	" users.id " .
				 " from users " .
				 	" inner join posts " .
					" on posts.user = users.id and posts.id = $_GET[id] " .
				 " where " .
				 	" users.name = '$_POST[name]' " .
					" and users.pass = '$_POST[pass]' ";
		if ( ! @mysql_fetch_assoc(mysql_query($sql)) )
			return 'either you entered the wrong username and password, or you do not have permission to edit this post';

		return FALSE;

	}

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	// trying to update a post
	if ( $_POST['action'] == 'edit_post' ) {

		if ( $errorString = errorCheck() )
			reportError( $errorString, " EditPost.php, id = $_GET[id], subject = $_POST[subject], user = $_POST[user], pass = $_POST[pass], body = $_POST[body], line_breaks = $_POST[line_breaks], action = $_POST[action] " );

		// all ok, update the post
		else {

			$subject = $_POST['subject'];
			$body = $_POST['body'];
			$line_breaks = ( $_POST['line_breaks'] ) ? 1 : 0;
			$public = ( ALLOW_PRIVATE_AMENDMENTS ) ? (( $_POST['public'] ) ? 1 : 0) : 1;

			// save amended copy
			$sql = " insert into amendments ( post, amended, subject, body, line_breaks, public ) " .
					 " select id, now(), subject, body, line_breaks, $public from posts where id = $_GET[id] ";
			mysql_query( $sql );

			// now update the new one
			$sql = " update posts " .
					 " set " .
					 	" subject = '$subject', " .
						" body = '$body', " .
						" line_breaks = $line_breaks " .
					 " where id = $_GET[id] ";
			mysql_query( $sql );

			?>
			
			<p id="MainTitle">:: edited</p>
			
			<p>
				[
					<a class="NavLink" href="index.php">home</a>
					| <a class="NavLink" href="ViewPost.php?id=<?php echo $_GET['id'] ?>">post</a>
					| <a class="NavLink" href="PostHistory.php?id=<?php echo $_GET['id'] ?>">history</a>
				]
			</p>
			
			<p>
				Your post has been edited.
			</p>

			<?php

		}

	}

	// no edit occurred so draw the form
	else {

		$sql = " select " .
				 	" posts.subject as post_subject, posts.body as post_body, posts.line_breaks as line_breaks, " .
					" users.name as user_name " .
				 " from posts " .
				 	" inner join users " .
					" on posts.user = users.id " .
				 " where posts.id = $_GET[id] ";
		$row = @mysql_fetch_assoc(mysql_query($sql));

		if ( !$row )
			reportError( 'the post requested does not exist', " EditPost.php, id = $_GET[id], sql = $sql " );

		else {
?>

<p id="MainTitle">:: edit</p>

<p class="NavLinks">
	[
		<a class="NavLink" href="index.php">home</a>
		| <a class="NavLink" href="javascript:location.reload('EditPost.php?id=<?php echo $_GET['id'] ?>')">refresh</a>
		| <a class="NavLink" href="ViewPost.php?id=<?php echo $_GET['id'] ?>">post</a>
	]
</p>

<p>
	To correct any retarded mistakes you made, just change em and
	click the update button at the bottom.
</p>

<form method="post" action="EditPost.php?id=<?php echo $_GET['id'] ?>" onsubmit="return checkForm(this)">

	<div class="Hidden">
		<input type="hidden" name="action" value="edit_post" />
	</div>

	<div>
		<span class="FormTitle">:: name and password</span><br />
		<input class="FormControl" type="text" name="name" size="34" maxlength="50" tabindex="1" value="<?php echo htmlspecialchars($row['user_name']) ?>" />
		<input class="FormControl" type="password" name="pass" size="23" maxlength="30" value="" tabindex="2" />
	</div>

	<div>
		<span class="FormTitle">:: subject</span><br />
		<input class="FormControl" type="text" name="subject" size="60" maxlength="60" tabindex="3" value="<?php echo htmlspecialchars($row['post_subject']) ?>" />
	</div>

	<div>
		<span class="FormTitle">:: message</span><br />
		<textarea class="FormControl" tabindex="4" name="body" cols="50" rows="15"><?php echo htmlspecialchars($row['post_body']) ?></textarea>
	</div>

	<p>

		Insert Line Breaks?
		<input type="checkbox" name="line_breaks" <?php echo ( $row['line_breaks'] ? 'checked="checked"' : '') ?> tabindex="6" />

		<?php if ( ALLOW_PRIVATE_AMENDMENTS ) { ?>
			<br />
			Make Old Version Public?
			<input type="checkbox" name="public" checked="checked" />
		<?php } ?>

	</p>

	<p>
		<input class="FormControl" type="submit" value="Update Message" tabindex="5" />
	</p>

</form>

<?php
		}

	}

	include 'Data/Inc/Footer.inc.php';

?>