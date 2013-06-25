<?php

	/**
	 *  admin editable constants
	 *
	 */

	define( 'ALLOW_BODY_HTML', TRUE ); // TRUE or FALSE
	define( 'ALLOW_PRIVATE_AMENDMENTS', TRUE ); // TRUE or FALSE
	define( 'DATE_FORMAT', 'jS F, Y \a\t G:i' ); // http://www.php.net/manual/en/function.date.php
	define( 'SEARCH_POSTS_PER_PAGE', 20 );
	define( 'THREADS_PER_PAGE', 20 );
	define( 'PAST_PAGE_LIMIT', 5 );
	define( 'USERS_PER_PAGE', 20 );
	define( 'DEFAULT_USER_COLOR', '000000' ); // hex value

	/**
	 *  database stuff
	 *
	 */

	define( 'DB_HOST', 'localhost' );
	define( 'DB_USER', '' );
	define( 'DB_PASS', '' );
	define( 'DB_NAME', '' );

	/**
	 *  system reliant constants
	 *
	 */

	define( 'SUBJECT_LENGTH', 60 );
	define( 'BLANK_DATE', '0000-00-00 00:00:00' ); // don't change unless there's a backend change

	/**
	 *  represents a user
	 *
	 */

	class User {
		var $id, $name, $color;
		function User( $id, $name, $color ) {
			if ( !$color ) $color = DEFAULT_USER_COLOR;
			$this->id = $id;
			$this->name = $name;
			$this->color = $color;
		}
	}

	/**
	 *  holds info about the post and the user that made it
	 *
	 */

	class Post {
		var $id, $parent, $subject, $user;
		function Post( $id, $parent, $subject, $user ) {
			$this->id = $id;
			$this->parent = $parent;
			$this->subject = $subject;
			$this->user = $user; // User object
		}
	}

	/**
	 *  draws one post to the given depth (default 0)
	 *
	 *  @param [post_id] the id of the post
	 *  @param [post_subject] the subject of the post
	 *  @param [user_id] the id of the user that made the post
	 *  @param [user_name] the name of that user
	 *
	 */

	function drawPost( $post_id, $post_subject, $user_id, $user_name, $user_color ) {
		?>
<a class="PostTitle" href="ViewPost.php?id=<?php echo $post_id ?>"><?php echo $post_subject ?></a>
	- <a class="User" style="color: #<?php echo $user_color ?>;" href="ViewUser.php?id=<?php echo $user_id ?>"><?php echo $user_name ?></a>
		<?php
	}


	/**
	 *  draws all the all posts below the given parent id
	 *  (NB, top posts will have parent == '')
	 *
	 *  @param [posts] an array of Post objects
	 *  @param [parent] (optional) the id of the parent post
	 *
	 */

	function drawPosts( $posts, $parent = '' ) {
		// loop through looking for replies
		for ( $i=0; $i<sizeof($posts); $i++ ) {
			$post = $posts[$i];
			// reply found! draw it and recurse
			if ( $post->parent == $parent ) {
				echo '<ul><li>';
				drawPost( $post->id, $post->subject, $post->user->id, $post->user->name, $post->user->color, $depth );
				drawPosts( $posts, $post->id );
				echo '</li></ul>';
			}
		}
	}

	/**
	 *  prints out an error message in a standard format for the user and logs it
	 *
	 *  @param [message] a description of the error for the user
	 *  @param [sys_message] (optional) a more detailed error description
	 *  @param [log_error] (optional) whether or not to log the error (needs db conn)
	 *
	 */

	function reportError( $message, $sys_message, $log_error = TRUE ) {
		?>

		<p id="MainTitle">:: burp</p>

		<p>
			[
			<a class="NavLink" href="index.php">home</a>
			| <a class="NavLink" href="javascript:history.back(1)">back</a>
			]
		</p>

		<p>Sorry, but there was an error.  It was probably because <?php echo $message ?>.</p>

		<?php

		// try and log the error, assumes db conn is open, doesn't really
		// matter if it's not, will die quietly
		if ( $log_error ) {
			$sql = " insert into errors ( user_desc, sys_desc, occurred ) " .
					 " values ( '$message', '$sys_message', NOW() ) ";
			@mysql_query( $sql );
		}

	}

	/**
	 *  draws links for pages which use the page argument
	 *
	 *  @param [less] boolean, if there are less pages
	 *  @param [more] boolean, if there are more pages
	 *  @param [page] the current page
	 *  @param [name] the name of the page (eg. index.php = index)
	 *
	 */

	function drawPageLinks( $less, $more, $page, $name ) {

		echo '<p class="NavLinks">[ ';

		// draw the links to different pages, kinda messy, but it kinda works
		if ( $less ) {

			$minpage = ( $page - PAST_PAGE_LIMIT > -1 ) ? $page - PAST_PAGE_LIMIT : 0;

			if ( $minpage > 0 )
				echo ' <a class="NavLink" href="' . $name . '">0</a> | ';
			if ( $minpage - 1 > 0 )
				echo ' ... | ';

			for ( $j=$minpage; $j<$page; $j++ )
				echo '<a class="NavLink" href="' . $name . 'page=' . $j . '">' . $j . '</a>' . (( $j < $page - 1 ) ? ' | ' : '');

		}

		// check if there are more pages, or we're at the end
		if ( $less && $more ) echo ' | ';
		echo ( $more ) ? '<a class="NavLink" href="' . $name . 'page=' . ($page + 1) . '">next -></a>'
							: (($less) ? ' | ' : '') . 'end';

		echo ' ]</p>';

	}

?>
