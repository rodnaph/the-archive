<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	$private = ( ALLOW_PRIVATE_AMENDMENTS ) ? ' ( 1 ) ' : ' ( 1, 0 ) ';
	$sql = " select " .
			 	" a.post as post, a.amended as amended, " .
				" a.subject as subject, a.body as body, a.line_breaks as line_breaks, a.public as public, " .
				" users.id as user_id, users.name as user_name, " .
				" max(prev.id) as prev_id, min(next.id) as next_id, max(prev.amended) as prev_date, " .
				" posts.posted as post_date " .
			 " from amendments a " .
			 	" inner join posts " .
				" on posts.id = a.post " .
				" inner join users " .
				" on users.id = posts.user " .
				" left outer join amendments prev " .
				" on prev.post = a.post and prev.id < a.id and prev.public in $private " .
				" left outer join amendments next " .
				" on next.post = a.post and next.id > a.id and next.public in $private " .
			 " where a.id = $_GET[id] and a.public in $private " .
			 " group by a.post ";
	$row = @mysql_fetch_assoc(mysql_query($sql));

	if ( !$row )
		reportError( 'that amendment does not exist or it is private', " ViewAmendment.php, id = $_GET[id], sql = $sql " );

	else {

		// the date the saved post was made/amended on
		$prev_date = ( $row['prev_date'] ) ? $row['prev_date'] : $row['post_date'];

		// format the post body
		$body = $row['body'];
		if ( !ALLOW_BODY_HTML )
			$body = htmlspecialchars($body);
		if ( $row['line_breaks'] )
			$body = str_replace( "\r\n", '<br />', $body );

?>

<p id="MainTitle">:: <?php echo $row['subject'] ?></p>

<p class="NavLinks">
	[
		<a class="NavLink" href="index.php">home</a>
		| <a class="NavLink" href="ViewPost.php?id=<?php echo $row['post'] ?>">post</a>
		| <a class="NavLink" href="PostHistory.php?id=<?php echo $row['post'] ?>">history</a>
	]
</p>

<p>
	This version was created on <?php echo date( DATE_FORMAT, strtotime($prev_date) ) ?> and amended on <?php echo date( DATE_FORMAT, strtotime($row['amended']) ) ?>
</p>

<p>
	Posted by <a class="User" href="ViewUser.php?id=<?php echo $row['user_id'] ?>"><?php echo $row['user_name'] ?></a>
</p>

<p id="PostBody">
	<?php echo $body ?>
</p>

<?php

		// just for ease
		$next = $row['next_id'];
		$prev = $row['prev_id'];

		// previous and next/current links
		echo '<p class="NavLinks">[ ';
		echo ( $prev ) ? '<a class="NavLink" href="ViewAmendment.php?id=' . $prev . '"><- prev</a>'
							: 'original';
		echo ' | ';
		echo ( $next ) ? '<a class="NavLink" href="ViewAmendment.php?id=' . $next . '">next -></a>'
							: '<a class="NavLink" href="ViewPost.php?id=' . $row['post'] . '">current</a>';
		echo ' ]</p>';

	}

	include 'Data/Inc/Footer.inc.php';

?>
