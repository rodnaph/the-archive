
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<p>
 <div class="Heading1">&lt; Search &gt;</div>
</p>

<p>
To search the Forum, just use the form below.  All you need to do is select the area
you would like to search, enter the keyword you want to use and then hit the search
button.
</p>

<form method="post" action="Search.asp">

  <input type="hidden" name="Action" value="DoSearch" />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0">

 <tr class="TableHeader">
  <td>
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Area:</span>
   </td></tr></table>
  </td>
  <td> &nbsp;

  <select name="Field" class="InputText">
    <option value="Name">User</option>
    <option value="Subject">Post Title</option>
    <option value="Message">Message</option>
  </select>

  </td>
 </tr>
 <tr class="TableHeader">
  <td width="65">
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Keyword:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input type="text" class="InputText" name="Keyword" size="85" maxlength="40" value="<%= Request.Form("Keyword") %>" /></td>
 </tr>
 <tr class="TableHeader">
  <td colspan="2" align="right">
   <input type="submit" value="Search" class="InputSubmit" />
   &nbsp;
  </td>
 </tr>
 </table>
</td></tr></table>

</form>

<% If Request.Form("Action") = "DoSearch" Then %>

<p>
 &lt;
  <span class="TitleLink">Search Results</span>
 &gt;
</p>

<ul>
<%

    Dim objPosts

    Set objPosts = Server.CreateObject( "ADODB.RecordSet" )
    objPosts.Open "SELECT * FROM qryPostsSearch WHERE " & Request.Form("Field") & " LIKE '%" & Request.Form("Keyword") & "%' ORDER BY Posts.DatePosted DESC", strConnect

    If objPosts.EOF Then
%>
<li>Sorry, but there was nothing found matching your search criterion.</li>
<%
    End If

    Do While Not objPosts.EOF

%>
 <li>
   <a class="TableItem" href="Post.asp?ThreadID=<%= objPosts("ThreadID") %>&PostID=<%= objPosts("PostID") %>&Depth=<%= objPosts("Depth") %>"><%= objPosts("Subject") %></a>
    - <a class="UserName" href="User.asp?UserID=<%= objPosts("UserID") %>"><%= objPosts("Name") %></a>
 </li>
<%

      objPosts.MoveNext

    Loop

    objPosts.Close

%>
</ul>

<% End If %>

<!--#include file="Data/Inc/Footer.asp"-->