
<%

  var isThread = isNaN( Request('PostID') ) ? true : false;
  var Action = ( isThread ) ? 'Thread' : 'Reply';
  var ReplyID = ( isThread ) ? -1 : Request('PostID');

%>

<a name="PostForm"></a>
<p>
  <b>Post Message</b>
</p>

<form method="post" action="Post.asp">

  <input type="hidden" name="ParentID" value="<%= ReplyID %>" />
  <input type="hidden" name="Action" value="<%= Action %>" />

  <b>Name</b><br />
  <input type="text" name="Name" size="58" maxlength="60" value="" />

  <br />

  <b>Password</b><br />
  <input type="password" name="Password" size="58" maxlength="60" value="" />

  <br />

  <b>Subject</b><br />
  <input type="text" name="Subject" size="58" maxlength="60" value="" />

  <br />

  <b>Message</b><br />
  <textarea name="Message" cols="50" rows="15"></textarea>

  <br /><br />

  <input type="submit" value="Post Message" />

</form>
