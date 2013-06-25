<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  draws a user in the list
	 *
	 *  @param [user_id] the users id
	 *  @param [user_name] the users name
	 *  @param [post_count] the users post count
	 *
	 */

	function drawUser( $user_id, $user_name, $post_count, $user_color ) {
		if ( !$user_color ) $user_color = DEFAULT_USER_COLOR;
		?>
<div class="UserInList">
	<span class="PostCount"><?php echo $post_count ?></span>
		- <a class="User" style="color: #<?php echo $user_color ?>;" href="ViewUser.php?id=<?php echo $user_id ?>"><?php echo $user_name ?></a>
</div>
		<?php
	}

?>

<p id="MainTitle">:: users</p>

<p>
	[
		<a class="NavLink" href="index.php">home</a>
		| <a class="NavLink" href="AddUser.php">register</a>
	]
</p>

<div id="UserListWrap">
	<div id="UserList">
<?php

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	$page = ( $_GET['page'] > 0 ) ? $_GET['page'] : 0;

	$sql = " select " .
			 	" users.id as user_id, users.name as user_name, " .
				" count(posts.id) as post_count, " .
				" colors.hex_value as user_color " .
			 " from users " .
			 	" left outer join posts " .
				" on posts.user = users.id " .
				" left outer join colors " .
				" on colors.id = users.color " .
			 " group by users.id " .
			 " order by post_count desc, users.name " .
			 " limit " . ( USERS_PER_PAGE * ($page + 1) );
	$res = mysql_query( $sql );

	// winding?
	$seek = $page * USERS_PER_PAGE;
	$seek = ( $seek < mysql_num_rows($res) ) ? $seek : -1;

	if ( $seek != -1 ) {

		mysql_data_seek( $res, $seek );

		$count = 0;
		// first column
		echo '<div id="UserFirstCol">';
		while ( ($count < (USERS_PER_PAGE / 2)) && ($row = mysql_fetch_assoc($res)) ) {
			drawUser( $row['user_id'], $row['user_name'], $row['post_count'], $row['user_color'] );
			$count++;
		}
		echo '</div><div id="UserSecondCol">';
		// second column
		while ( $row = mysql_fetch_assoc($res) ) {
			drawUser( $row['user_id'], $row['user_name'], $row['post_count'], $row['user_color'] );
			$count++;
		}
		echo '</div>';

	}
	
	else echo '<p>(none)</p>';

?>

	</div>

<?php

	// page links
	$less = ( $page > 1 );
	$more = ( $count == USERS_PER_PAGE );
	drawPageLinks( $less, $more, $page, 'ListUsers.php?' );

?>

</div>

<?php

	include 'Data/Inc/Footer.inc.php';

?>
