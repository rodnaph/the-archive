
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->
<!--#include file="Data/Inc/PostsLib.asp"-->

<%

  Dim strParentID

  strParentID = 0

%>

<p>
 <div class="Heading1">&lt; Threads &gt;</div>
</p>

<p>
&lt;
 <a class="TitleLink" href="#PostForm">Reply</a> :
 <a class="TitleLink" href="javascript:location.reload('Thread.asp?ThreadID=<%= Request("ThreadID") %>')">Refresh</a>
&gt;
</p>

<%

  Dim objConn, objComm, objPosts, threadID, objThread, strSubject, strCreated, strOwner

  threadID = Request("ThreadID")

  Set objComm = Server.CreateObject( "ADODB.Command" )
  objComm.ActiveConnection = strConnect
  objComm.CommandType = adCmdStoredProc
  objComm.CommandText = "qryThreadByID"
  objComm.Parameters.Append( objComm.CreateParameter( "ID", adSmallInt, adParamInput, 50, threadID ) )

  Set objThread = objComm.Execute

  Set objComm = Nothing

  '  setup connection object
  Set objPosts = Server.CreateObject( "ADODB.RecordSet" )
  objPosts.Open "SELECT * FROM Users INNER JOIN Posts ON Users.UserID = Posts.UserID WHERE ThreadID = " & threadID & " ORDER BY Posts.DatePosted DESC", strConnect, adOpenDynamic

%>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td width="60"> &nbsp; <span class="TableSubTitle">Title:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objThread("Subject") %></span></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">User:</span></td>
   <td> &nbsp; <a class="UserName" href="User.asp?UserID=<%= objThread("UserID") %>"><%= objThread("Name") %></a></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Created:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objThread("DateCreated") %></span></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Last Post:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objThread("LastPost") %></span></td>
  </tr>
  <tr class="TableMain">
   <td colspan="2">
    <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>
      <span class="TableItem"><%= objThread("Message") %></span>
    </td></tr></table>
   </td>
  </tr>
 </table>
</td></tr></table>

<br />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableTitle">Subject</span></td>
   <td align="center"><span class="TableTitle">User</span></td>
   <td align="center"><span class="TableTitle">Posted On</span></td>
  </tr>
<%

  '  draw posts out

  Dim CurrID

  Do While Not objPosts.EOF

    If objPosts("Depth") = 1 Then

      drawReply objPosts, 1
      CurrID = objPosts("PostID")

      drawReplies objPosts, 1

      objPosts.MoveFirst
      objPosts.Find "PostID = " & CurrID

    End If

    objPosts.MoveNext

  Loop

%>

 </table>
</td></tr></table>

<!--#include file="Data/Inc/PostForm.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->