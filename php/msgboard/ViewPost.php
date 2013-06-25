<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  indicates whether there are any replies to this post
	 *  in the posts array
	 *
	 *  @param [posts] an array of Post objects
	 *
	 */

	function has_replies( $posts ) {
	
		for ( $i=0; $i<sizeof($posts); $i++ )
			if ( $posts[$i]->parent == $_GET['id'] ) return true;
			
		return false;

	}

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	// information about the post
	$sql = " select " .
			 	" posts.thread as post_thread, posts.parent as post_parent, posts.subject as post_subject, posts.body as post_body, posts.posted as post_date, posts.line_breaks as line_breaks, " .
				" users.id as user_id, users.name as user_name, colors.hex_value as user_color, " .
				" max(amendments.amended) as amended_date, count(amendments.id) as amended_count " .
			 " from posts " .
			 	" inner join users " .
				" on users.id = posts.user " .
				" left outer join amendments " .
				" on amendments.post = posts.id " .
				" left outer join colors " .
				" on colors.id = users.color " .
			 " where posts.id = $_GET[id] " .
			 " group by posts.id ";
	$res = mysql_query( $sql );
	$post = @mysql_fetch_array( $res );

	// check the post was found )
	if ( !$post )
		reportError( 'the requested post does not exist', " ViewPost.php, posts.id = $_GET[id], sql = $sql " );

	else {

		// store for later
		$pf_thread = $post['post_thread'];

		// create the message body
		$body = $post['post_body'];
		if ( !ALLOW_BODY_HTML )
			$body = htmlspecialchars($body);
		if ( $post['line_breaks'] )
			$body = str_replace( "\r\n", '<br />', $body );
			
		// check color
		if ( !$post['user_color'] )
			$post['user_color'] = DEFAULT_USER_COLOR;

?>

<p id="MainTitle">:: <?php echo $post['post_subject'] ?></p>

<p>
	[
		<a class="NavLink" href="#Post">submit</a>
		| <a class="NavLink" href="javascript:location.reload()">refresh</a>
		| <a class="NavLink" href="<?php echo ( $post['post_parent'] == '' ) ? 'index.php' : "ViewPost.php?id=$post[post_parent]" ?>">parent</a>
		| <a class="NavLink" href="index.php">home</a>
	]
</p>

<p>
	Posted by <a class="User" style="color: #<?php echo $post['user_color'] ?>;" href="ViewUser.php?id=<?php echo $post['user_id'] ?>"><?php echo $post['user_name'] ?></a>
	on <?php echo date( DATE_FORMAT, strtotime($post['post_date']) ) ?>
	<?php if ( $post['amended_date'] ) { ?>
		and <?php if ( $post['amended_count'] > 1 ) echo 'last ' ?>amended on <?php echo date( DATE_FORMAT, strtotime($post['amended_date']) ) ?>
	<?php } ?>
</p>

<p id="PostBody">
	<?php echo $body ?>
</p>

<?php

		// now need to get info about the posts replies
		$sql = " select " .
					" posts.id as post_id, posts.parent as post_parent, posts.subject as post_subject, " .
					" users.id as user_id, users.name as user_name, colors.hex_value as user_color " .
				" from posts " .
					" inner join users " .
					" on users.id = posts.user " .
					" left outer join colors " .
					" on colors.id = users.color " .
				" where " .
					" posts.thread = $post[post_thread] " .
					" and posts.id > $_GET[id] " .
				" order by posts.id desc ";
		$res = mysql_query( $sql );

		// create post objects from info retrieved
		$posts = array();
		while ( $row = mysql_fetch_array($res) )
			array_push( $posts, new Post( $row['post_id'], $row['post_parent'], $row['post_subject'], new User($row['user_id'],$row['user_name'],$row['user_color']) ) );

		// check if there are any replies
		if ( has_replies($posts) )
			echo '<p class="SmallTitle">:: replies</p>';

		drawPosts( $posts, $_GET['id'] );

		// posting form
		$pf_parent = $_GET['id'];
		// $pf_thread is set earlier on this page
		include 'Data/Inc/PostForm.inc.php';

	}

?>

<p class="NavLinks">
	[
		<a class="NavLink" href="EditPost.php?id=<?php echo $_GET['id'] ?>">edit</a>
		<?php if ( $post['amended_date'] ) { ?>
			| <a class="NavLink" href="PostHistory.php?id=<?php echo $_GET['id'] ?>">history</a>
		<?php } ?>
	]
</p>

<?php

	include 'Data/Inc/Footer.inc.php';

?>
