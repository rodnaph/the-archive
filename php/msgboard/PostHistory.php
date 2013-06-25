<?php

	include 'Data/Inc/Common.inc.php';
	include 'Data/Inc/Header.inc.php';

	mysql_connect( DB_HOST, DB_USER, DB_PASS );
	mysql_select_db( DB_NAME );

	$sql = " select subject from posts where id = $_GET[id] ";
	$row = @mysql_fetch_assoc(mysql_query($sql));

	if ( !$row )
		reportError( 'the requested post was not found', " PostHistory.php, id = $_GET[id], sql = $sql " );

	else {

?>

<p id="MainTitle">:: history for <span id="PostTitleBig"><?php echo $row['subject'] ?></span></p>

<p class="NavLinks">
	[
		<a class="NavLink" href="index.php">home</a>
		| <a class="NavLink" href="ViewPost.php?id=<?php echo $_GET['id'] ?>">post</a>
	]
</p>

<?php

		$sql = " select " .
					" a.id as amend_id, a.amended as amended, " .
					" a.subject as subject, a.public as public " .
				" from amendments a " .
				" where a.post = $_GET[id] ";
		$res = mysql_query( $sql );

		while ( $row = mysql_fetch_assoc($res) ) {
			?>

			<div class="Amendment">
				<?php echo date( DATE_FORMAT, strtotime($row['amended']) ) ?> -
				<?php if ( $row['public'] || !ALLOW_PRIVATE_AMENDMENTS ) { ?>
					<a class="PostTitle" href="ViewAmendment.php?id=<?php echo $row['amend_id'] ?>"><?php echo $row['subject'] ?></a>
				<?php } else { ?>
					PRIVATE
				<?php } ?>
			</div>

			<?php
		}

	}

	include 'Data/Inc/Footer.inc.php';

?>
