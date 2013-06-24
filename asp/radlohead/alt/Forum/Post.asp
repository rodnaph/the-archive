
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->
<!--#include file="Data/Inc/PostsLib.asp"-->

<p>
 <div class="Heading1">&lt; Posts &gt;</div>
</p>

<%

  Dim objComm, objPost, strParentID, ParentID

  Set objComm = Server.CreateObject( "ADODB.Command" )
  objComm.ActiveConnection = strConnect
  objComm.CommandType = adCmdStoredProc
  objComm.CommandText = "qryPostByID"
  objComm.Parameters.Append( objComm.CreateParameter( "ID", adSmallInt, adParamInput, 50, Request("PostID") ) )

  Set objPost = objComm.Execute
  Set objComm = Nothing

  strParentID = objPost("PostID")
  ParentID = objPost("ParentID")

%>

<p>
&lt;
 <a class="TitleLink" href="Thread.asp?ThreadID=<%= Request("ThreadID") %>">Thread</a> :
 <a class="TitleLink" href="#PostForm">Reply</a>

<%
  ' try to draw parent link
  If ParentID > 0 Then
%>
: <a class="TitleLink" href="Post.asp?ThreadID=<%= Request("ThreadID") %>&PostID=<%= objPost("ParentID") %>&Depth=<%= Request("Depth") - 1 %>">Parent</a>
<%
  End If
%>

: <a class="TitleLink" href="javascript:location.reload('Post.asp?<%= Request.QueryString %>')">Refresh</a>

&gt;
</p>

<%

  drawPost( objPost )

  Dim objPosts

  '  setup connection object
  Set objPosts = Server.CreateObject( "ADODB.RecordSet" )
  objPosts.Open "SELECT * FROM Users INNER JOIN Posts ON Users.UserID = Posts.UserID WHERE ThreadID = " & Request("ThreadID") & " AND Depth > " & Request("Depth") - 1 & " ORDER BY Posts.DatePosted DESC", strConnect, adOpenDynamic
  objPosts.Find "PostID = " & Request("PostID")

  Dim closeTable

  closeTable = False

  If Not objPosts.EOF Then

    closeTable = True
%>
<br />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableTitle">Subject</span></td>
   <td align="center"><span class="TableTitle">User</span></td>
   <td align="center"><span class="TableTitle">Posted On</span></td>
  </tr>

<%

  End If

  drawReplies objPosts, (objPosts("Depth") / 1) + 1

  If closeTable Then

%>

 </table>
</td></tr></table>
<%
  End If
%>

<!--#include file="Data/Inc/PostForm.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->