<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	$sql = " select " .
			 	" users.name as name, count(posts.id) as post_count, users.email as email " .
			 " from users " .
			 	" left outer join posts " .
				" on posts.user = users.id " .
			 " where users.id = $_GET[id] " .
			 " group by users.name ";
	$res = mysql_query( $sql );
	$row = @mysql_fetch_assoc($res);
	
	if ( !$row )
		reportError( 'the user requested does not exist', " ViewUser.php, users.id = $_GET[id] " );

	else {
?>

<p id="MainTitle">:: <?php echo $row['name'] ?></p>

<p>
	[
		<a class="NavLink" href="index.php">home</a>
		| <a class="NavLink" href="javascript:location.reload()">refresh</a>
		| <a class="NavLink" href="Search.php?user=<?php echo $row['name'] ?>">posts</a>
	]
</p>

<p>
	<b>Posts:</b> <?php echo $row['post_count'] ?><br />
	<b>Email:</b> <?php echo $row['email'] ?>
</p>

<?php
	}

	include 'Data/Inc/Footer.inc.php';

?>
