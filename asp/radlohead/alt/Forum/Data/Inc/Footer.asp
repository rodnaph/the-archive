
<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
 <td>

<% If allowSkins Then %>
  <!--#include file="SkinForm.asp"-->
<% End If %>

 </td>
 <td align="right" valign="top">

&lt;

<% If Session("ForumLogin") = "Done" Then %>
  <a class="TitleLink" href="Logout.asp">Logout <b><%= Session("Name") %></b></a> :
<% End If %>

 <a class="TitleLink" href="Help.asp">Help</a>

<% If Session("Admin") Then %>
  : <a class="TitleLink" href="Admin.asp">Admin</a>
<% End If %>

&gt;

  </td>
 </tr>
</table>

</body>
</html>

<%
  Response.End
%>