<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

?>

<p id="MainTitle">:: info</p>

<p class="NavLinks">
	[
		<a class="NavLink" href="index.php">home</a>
	]
</p>

<p>
<?php

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	// post count
	$sql = " select count(posts.id) as count from posts ";
	$posts = mysql_fetch_assoc(mysql_query($sql));

	// thread count
	$sql = " select count(threads.id) as count from threads ";
	$threads = mysql_fetch_assoc(mysql_query($sql));

	// user count
	$sql = " select count(users.id) as count from users ";
	$users = mysql_fetch_assoc(mysql_query($sql));

	$info = array(
						'Total Threads', $threads['count'],
						'Total Posts', $posts['count'],
						'Total Users', $users['count'],
						'Body HTML Allowed', (( ALLOW_BODY_HTML ) ? 'Yes' : 'No'),
						'Private Amendments', (( ALLOW_PRIVATE_AMENDMENTS ) ? 'Yes' : 'No'),
						'Date Format (date function)', DATE_FORMAT,
						'Search Posts Per Page', SEARCH_POSTS_PER_PAGE,
						'Threads Per Page', THREADS_PER_PAGE,
						'Past Page Limit (on page links)', PAST_PAGE_LIMIT,
						'Users Per Page', USERS_PER_PAGE,
						'Default User Color', '#' . DEFAULT_USER_COLOR );

	for ( $i=0; $i<sizeof($info); $i+=2 ) {
		?>
		<div class="Info">
			<span class="SmallTitle"><?php echo $info[$i] ?>:</span>
			<?php echo $info[$i+1] ?>
		</div>
		<?php
	}

?>
</p>

<?php

	include 'Data/Inc/Footer.inc.php';

?>
