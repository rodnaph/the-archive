<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	/**
	 *  represents a single thread, contains all the posts for
	 *  that thread
	 *
	 */

	class Thread {
		var $id, $posts;
		function Thread( $id ) {
			$this->id = $id;
			$this->posts = array();
		}
		// adds a post to this thread
		function addPost( $id, $parent, $subject, $user_id, $user_name, $user_color ) {
			array_push( $this->posts, new Post( $id, $parent, $subject, new User($user_id,$user_name,$user_color) ) );
		}
	}

?>

<p id="MainTitle">:: dboard</p>

<p>
	[
		<a class="NavLink" href="#Post">submit</a>
		| <a class="NavLink" href="javascript:location.reload()">refresh</a>
		| <a class="NavLink" href="Search.php">search</a>
		| <a class="NavLink" href="ListUsers.php">users</a>
		| <a class="NavLink" href="AddUser.php">register</a>
		| <a class="NavLink" href="../">home</a>
	]
</p>

<?php

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	// get top thread id so we can work out the id of the thread to fetch to
	$sql = " select MAX(id) as max_id from threads ";
	$row = mysql_fetch_assoc(mysql_query($sql));
	$page = ( $_GET['page'] > 0 ) ? $_GET['page'] : 0;
	$thread = $row['max_id'] - ($page * THREADS_PER_PAGE);

	// query for threads
	$sql = " select " .
				" threads.id as thread_id, " .
				" posts.id as post_id, posts.parent as post_parent, posts.subject as post_subject, " .
				" users.id as user_id, users.name as user_name, colors.hex_value as user_color " .
			 " from threads " .
			 	" left outer join posts " .
				" on posts.thread = threads.id " .
				" inner join users " .
				" on users.id = posts.user " .
				" left outer join colors " .
				" on users.color = colors.id " .
			 " where threads.id <= $thread and threads.id > " . ($thread - THREADS_PER_PAGE) .
			 " order by threads.id desc, posts.posted desc ";
	$res = mysql_query( $sql );

	// some vars
	$thread_id = -1;
	$curr_thread;
	$threads = array();

	// extract info from recordset into objects
	while ( $row = mysql_fetch_array($res) ) {
		// create a new thread if needed
		if ( $row['thread_id'] != $thread_id ) {
			// add old thread to array
			if ( $thread_id != -1 )
				array_push( $threads, $curr_thread );
			$curr_thread = new Thread( $row['thread_id'] );
			$thread_id = $row['thread_id'];
		}
		// add post to thread
		$curr_thread->addPost( $row['post_id'], $row['post_parent'], $row['post_subject'], $row['user_id'], $row['user_name'], $row['user_color'] );
	}

	// add last thread to array
	if ( $thread_id != -1 )
		array_push( $threads, $curr_thread );

	// now need to draw all the threads onto the page
	for ( $i=0; $i<sizeof($threads); $i++ )
		drawPosts( $threads[$i]->posts );

	// page links
	$less = ( $page - 1 > -1 );
	$more = ( $i == THREADS_PER_PAGE );
	drawPageLinks( $less, $more, $page, 'index.php?' );

	// now to include the posts forrm
	$pf_thread = -1;
	$pf_parent = -1;
	include 'Data/Inc/PostForm.inc.php';

?>

<p class="NavLinks">
	[
		<a class="NavLink" href="Info.php">info</a>
	]
</p>

<?php

	include 'Data/Inc/Footer.inc.php';

?>
