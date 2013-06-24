  </td></tr></table>

  </td>
 </tr>
</table>

<br />

<table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td></td>
  <td></td>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
 </tr>
 <tr>
  <td>
   &nbsp; &nbsp;
   <b><a href="http://www.ill-odium.co.uk" target="_blank">Product</a></b>
  </td>
  <td width="20"><img src="/Data/Images/bottom_divide.gif" height="20" width="20" alt="" /></td>
  <td bgcolor="#eeeeee">

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr><td align="right">
    
    &nbsp;
<%

  // set login text
  var loginText = ( Session('loggedIn') == true ) ? 'Logout ' +Session('loginName') : 'Login';
  var loginLink = ( Session('loggedIn') == true ) ? 'Logout' : 'Login';

%>
    <b><a href="/<%= loginLink %>.asp"><%= loginText %></a></b> |
    <b><a href="<%= Request.ServerVariables('url')+ '?style=' +styleLink %>"><%= styleText %></a></b> |
    <b><a href="/Feedback/Contact.asp">Contact</a></b> |
    <b><a href="/Admin">Admin</a></b>
    
    &nbsp; &nbsp;
    
   </td></tr></table>

  </td>

 </tr>
</table>

</body>
</html>
<%

  objGlobNodes.Close();

  Response.End();

%>
