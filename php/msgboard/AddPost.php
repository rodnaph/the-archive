<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  checks the submission for errors, if any found returns a string
	 *  describing the error, otherwise returns FALSE indicating all ok
	 *
	 *  NB, the var $user_id is set here
	 *
	 */

	$user_id = -1;

	function errorCheck() {

		global $user_id;

		// check required fields present
		$required = array( 'name', 'subject', 'body' );
		for ( $i=0; $i<sizeof($required); $i++ )
			if ( $_POST[$required[$i]] == '' ) return 'you missed a required field';

		// check username is ok
		$sql = " select id, pass from users where name like '" . htmlspecialchars(trim($_POST[name])) . "' ";
		$res = mysql_query( $sql );
		$row = mysql_fetch_assoc($res);
		if ( $row['pass'] != $_POST['pass'] )
			return 'you entered an invalid username/password combination';
		// will need this later
		$user_id = $row['id'];

		// just check all really did go well
		if ( $user_id == -1 )
			return 'something very wierd happened';

		return FALSE;

	}

	// connect to db
	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	if ( $errorString = errorCheck() )
		reportError( $errorString, " AddPost.php, user_id = $user_id, subject = $_POST[subject], body = $_POST[body], pass = $_POST[pass], thread = $_POST[thread], parent = $_POST[parent], line_breaks = $_POST[line_breaks] " );

	// all ok, go ahead and post message
	else {
		// setting some stuff
		$parent = ( $_POST['parent'] == -1 ) ? 'NULL' : $_POST['parent'];
		$subject = htmlspecialchars( trim(substr($_POST['subject'],0,SUBJECT_LENGTH)) );
		$body = $_POST['body'];
		$line_breaks = $_POST['line_breaks'] ? 1 : 0;

		// is this a new thread?  if it is need to create one
		$thread = $_POST['thread'];
		if ( $thread == -1 ) {
			$sql = " insert into threads ( ) " .
					 " values ( ) ";
			mysql_query( $sql );
			$thread = mysql_insert_id();
		}

		// setting some stuff
		$parent = ( $_POST['parent'] == -1 ) ? 'NULL' : $_POST['parent'];
		$subject = htmlspecialchars( trim(substr($_POST['subject'],0,SUBJECT_LENGTH)) );
		$body = $_POST['body'];
		$line_breaks = $_POST['line_breaks'] ? 1 : 0;

		// ok to insert record now
		$sql = " insert into posts ( thread, user, posted, parent, subject, body, line_breaks ) " .
				 " values ( $thread, $user_id, NOW(), $parent, '$subject', '$body', $line_breaks ) ";
		mysql_query( $sql );

		?>

		<p id="MainTitle">:: posted</p>

		<p>
			[
				<a class="NavLink" href="index.php">home</a>
				| <a class="NavLink" href="ViewPost.php?id=<?php echo mysql_insert_id() ?>">post</a>
			]
		</p>

		<p>
			Your message has been posted.
		</p>

		<?php

	}

	include 'Data/Inc/Footer.inc.php';

?>
