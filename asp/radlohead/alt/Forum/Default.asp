
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<p>
 <div class="Heading1">&lt; Forum &gt;</div>
</p>

<p>
&lt;
 <a class="TitleLink" href="NewThread.asp">Thread</a> :
 <a class="TitleLink" href="javascript:location.reload('Default.asp')">Refresh</a>
&gt;
</p>

<%

  Dim objComm, objThreads, offset, THREADS_PER_PAGE

  ' set offset
  THREADS_PER_PAGE = 15
  offset = Request("offset")

  If offset = "" Or offset < 0 Then
    offset = 0
  End If

  Set objComm = Server.CreateObject( "ADODB.Command" )
  objComm.ActiveConnection = strConnect
  objComm.CommandText = "qryAllThreads"
  objComm.CommandType = adCmdStoredProc

  Set objThreads = objComm.Execute

%>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableTitle">Title</span></td>
   <td align="center"><span class="TableTitle">Last Post</span></td>
   <td align="center"><span class="TableTitle">User</span></td>
   <td align="center"><span class="TableTitle">Posts</span></td>
  </tr>
<%

  Dim threadCount

  threadCount = 0

  If Not objThreads.EOF Then
    objThreads.Move offset
  End If

  Do While Not objThreads.EOF And threadCount < THREADS_PER_PAGE

%>
  <tr class="TableMain" onmouseover="highlightItem(this,Colors.OVER_ITEM_COLOR)" onmouseout="highlightItem(this,Colors.OFF_ITEM_COLOR)">
   <td>
    &nbsp; <img src="Data/Skins/<%= Session("Skin") %>/Images/arrow.gif" alt="" /> &nbsp;
    <a class="TableItem" href="Thread.asp?ThreadID=<%= objThreads("ThreadID") %>"><%= objThreads("Subject") %></a>
   </td>
   <td align="center" width="110">
     <span class="TableItem"><%= objThreads("LastPost") %></span>
   </td>
   <td align="center">
     <a class="UserName" href="User.asp?UserID=<%= objThreads("UserID") %>"><%= objThreads("Name") %></a>
   </td>
   <td align="center">
    <span class="TableItem"><%= objThreads("NoOfPosts") %></span>
   </td>
  </tr>
<%

    threadCount = threadCount + 1
    objThreads.MoveNext()

  Loop

%>

 </table>
</td></tr></table>

<%

  '  draw links for moving through pages of threads

  If offset > 0 Or Not objThreads.EOF Then
%>

<br />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0"><tr class="TableHeader"><td>
  <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
   <td>
   &nbsp;
<%

    If offset > 0 Then
%>
 <a href="Default.asp?offset=<%= offset - THREADS_PER_PAGE %>"><tt>&lt;-</tt> Back</a>
<%
    End If
%>
   </td>
   <td align="right">
<%
    If Not objThreads.EOF Then
%>
  <a href="Default.asp?offset=<%= offset + THREADS_PER_PAGE %>">More <tt>-&gt;</tt></a>
<%
    End If
%>
   &nbsp;
   </td></tr></table>
 </td></tr></table>
</td></tr></table>

<%

  End If

%>

<br />

<!--#include file="Data/Inc/Footer.asp"-->