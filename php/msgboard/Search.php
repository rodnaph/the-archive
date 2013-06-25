<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  adding a clause to a where statement
	 *
	 *  @param [clause] the clause to add (eg. " name = 'foo' " )
	 *
	 */

	function addClause( $clause ) {

		global $whereClause;

		$whereClause .= ( $whereClause ) ? ' and ' : ' where ';
		$whereClause .= $clause;

	}

?>

<p id="MainTitle">:: search</p>

<p>
	[
		<a class="NavLink" href="index.php">home</a>
	]
</p>

<form method="get" action="Search.php">

	<div>
		<span class="FormTitle">User:</span><br />
		<input class="FormControl" type="text" name="user" size="50" maxlength="50" value="<?php echo htmlspecialchars(stripcslashes($_GET['user'])) ?>" />
	</div>

	<div>
		<span class="FormTitle">Subject contains:</span><br />
		<input class="FormControl" type="text" name="subject" size="50" maxlength="60" value="<?php echo htmlspecialchars(stripcslashes($_GET['subject'])) ?>" />
	</div>

	<div>
		<span class="FormTitle">Body contains:</span><br />
		<input class="FormControl" type="text" name="body" size="50" maxlength="60" value="<?php echo htmlspecialchars(stripcslashes($_GET['body'])) ?>" />
	</div>

	<p><input class="FormControl" type="submit" value="Search" /></p>


</form>

<hr />

<?php

	// build the search where clause
	$whereClause = ''; // init this just incase
	// user
	if ( $_GET['user'] )
		addClause( " users.name = '" . mysql_escape_string($_GET[user]) . "' " );
	// subject
	if ( $_GET['subject'] )
		addClause( " subject like '%$_GET[subject]%' " );
	// body
	if ( $_GET['body'] )
		addClause( " body like '%$_GET[body]%' " );

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	$page = ( $_GET['page'] > 0 ) ? $_GET['page'] : 0;
	$sql = " select " .
			 	" posts.id as post_id, posts.subject as post_subject, " .
				" users.id as user_id, users.name as user_name, " .
				" colors.hex_value as user_color " .
			 " from posts " .
			 	" inner join users " .
				" on users.id = posts.user " .
				" left outer join colors " .
				" on colors.id = users.color " .
			 " $whereClause " .
			 " order by posts.id desc " .
			 " limit " . ($page*SEARCH_POSTS_PER_PAGE) . ", " . (SEARCH_POSTS_PER_PAGE + 1);
	$res = mysql_query( $sql );

	// draw the results
	$count = 0;
	echo '<ul>';
	while ( ($row = mysql_fetch_assoc($res)) && ($count++ < SEARCH_POSTS_PER_PAGE) ) {
		echo '<li>';
		drawPost( $row['post_id'], $row['post_subject'], $row['user_id'], $row['user_name'], $row['user_color'] );
		echo '</li>';
	}
	echo '</ul>';

	if ( $count == 0 )
		echo '<p style="font-style: italic;">no results</p>';

	// page links
	drawPageLinks( ($page>0), ($count>SEARCH_POSTS_PER_PAGE), $page,
						'Search.php?user=' . urlencode(stripcslashes($_GET['user']))
												 . '&amp;subject=' . urlencode(stripcslashes($_GET['subject']))
												 . '&amp;body=' . urlencode(stripcslashes($_GET['body'])) . '&amp;'
					 );

	include 'Data/Inc/Footer.inc.php';

?>
