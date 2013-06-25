<?php

	// NB!!
	//
	// this include assumes that $pf_thread, and $pf_parent are set
	// to whatever they should be.
	//

?>

<p class="SmallTitle"><a id="Post"></a>:: post message</p>

<form method="post" action="AddPost.php" onsubmit="return checkForm(this,'name','pass','subject','body')">

	<div class="Hidden">
		<input type="hidden" name="thread" value="<?php echo $pf_thread ?>" />
		<input type="hidden" name="parent" value="<?php echo $pf_parent ?>" />
	</div>

	<div>
		<span class="FormTitle">:: name and password</span><br />
		<input class="FormControl" type="text" name="name" size="34" maxlength="50" tabindex="1" />
		<input class="FormControl" type="password" name="pass" size="23" maxlength="30" value="" tabindex="2" />
	</div>

	<div>
		<span class="FormTitle">:: subject</span><br />
		<input class="FormControl" type="text" name="subject" size="60" maxlength="60" tabindex="3" />
	</div>

	<div>
		<span class="FormTitle">:: message</span><br />
		<textarea class="FormControl" tabindex="4" name="body" cols="50" rows="15"></textarea>
	</div>

	<p>
		<input class="FormControl" type="submit" value="Post Message" tabindex="5" />
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
		Insert Line Breaks?
		<input type="checkbox" name="line_breaks" checked="checked" tabindex="6" />
	</p>

</form>
