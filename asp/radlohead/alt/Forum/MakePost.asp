
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->
<!--#include file="Data/Inc/PostsLib.asp"-->

<p>
 <div class="Heading1">&lt; Posting &gt;</div>
</p>

<%

  '
  '  first add new post
  '

  Dim objPosts, newPostID, strSubject, strMessage

  newPostID = 1
  depth = Request.Form("Depth") + 1
  strSubject = Server.HTMLEncode( Request.Form("Subject") )
  strMessage = Server.HTMLEncode( Request.Form("Message") )

  If strMessage = "" Or strSubject = "" Then
%>

<p>
 Sorry, but there was an error posting your message.  This will be for one of the
 following reasons.
</p>

<ul>
 <li class="ListBullet">You missed out a field.</li>
 <li class="ListBullet">The post data was somehow corrupted.</li>
</ul>

<p>
 Please try again.
</p>

<!--#include file="Data/Inc/Footer.asp"-->	
<%
  End If

  ' edit params
  strMessage = Replace( strMessage, vbCr, "<br />" )

  Set objPosts = Server.CreateObject( "ADODB.RecordSet" )

  objPosts.Open "Posts", strConnect, adOpenDynamic, adLockPessimistic

  '  set new id

  If Not objPosts.EOF Then

    objPosts.MoveLast
    newPostID = objPosts("PostID") + 1

  End If

  '  create new post

  objPosts.AddNew
  objPosts("PostID") = newPostID
  objPosts("UserID") = Session("UserID")
  objPosts("ThreadID") = Request.Form("ThreadID")
  objPosts("Subject") = strSubject
  objPosts("Message") = strMessage
  objPosts("Depth") = depth
  objPosts("DatePosted") = Now
  objPosts("ParentID") = Request.Form("ParentID")
  objPosts.Update
  objPosts.Close

  '
  '  then update the thread table
  '

  Dim objThreads, noOfPosts

  Set objThreads = Server.CreateObject( "ADODB.RecordSet" )

  objThreads.Open "Threads", strConnect, adOpenDynamic, adLockPessimistic
  objThreads.Find "ThreadID = " & Request.Form("ThreadID")
  noOfPosts = objThreads("NoOfPosts") + 1
  objThreads("NoOfPosts") = noOfPosts
  objThreads("LastPost") = Now
  objThreads.Update
  objThreads.Close

  '
  '  then update user table
  '

  Dim objUsers

  Set objUsers = Server.CreateObject( "ADODB.RecordSet" )

  objUsers.Open "Users", strConnect, adOpenDynamic, adLockPessimistic
  objUsers.Find "UserID = " & Session("UserID")
  noOfPosts = objUsers("NoOfPosts") + 1
  objUsers("NoOfPosts") = noOfPosts
  objUsers("LastPost") = Now
  objUsers.Update
  objUsers.Close

%>

<p>
&lt;
 <a class="TitleLink" href="Thread.asp?ThreadID=<%= Request.Form("ThreadID") %>">Thread</a> :
 <a class="TitleLink" href="Post.asp?ThreadID=<%= Request.Form("ThreadID") %>&PostID=<%= newPostID %>&Depth=<%= depth %>">Post</a>
&gt;
</p>

<p>
 Success!  <span class="UserName"><%= Session("Name") %></span>, you post  has been added.  The <b>Thread</b> link above will
 take you back to the thread you were posting a message in, the <b>Post</b> link will
 take you straight to your new post.
</p>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td width="40"> &nbsp; <span class="TableSubTitle">Title:</span></td>
   <td>
   &nbsp;
   <span class="TableItem"><%= strSubject %></span>
   </td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">User:</span></td>
   <td>
    &nbsp;
    <a class="UserName" href="User.asp?UserID=<%= Session("UserID") %>"><%= Session("Name") %></a>
   </td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Date:</span></td>
   <td>
     &nbsp;
     <span class="TableItem"><%= Now %></span>
   </td>
  </tr>
  <tr class="TableMain">
   <td colspan="2">
    <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>
      <span class="TableItem"><%= strMessage %></span>
    </td></tr></table>
   </td>
  </tr>
 </table>
</td></tr></table>

<br />

<!--#include file="Data/Inc/Footer.asp"-->