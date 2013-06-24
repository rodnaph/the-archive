<!--#include virtual="/Data/Inc/AdminPassword.asp"-->
<%

  If Request.Form("Action") = "AdminLogin" Then

    If Request.Form("Password") = adminPassword Then
      Session("AdminLogin") = "Yes"
    End If

  End If

  If Session("AdminLogin") <> "Yes" Then
%>
<html>
<head>
<title>Login</title>
</head>

<body>

<h2>Login</h2>

<form method="post" action="<%= Request.ServerVariables("URL") %>">

  <input type="hidden" name="Action" value="AdminLogin" />

  Password:<br />
  <input type="password" name="Password" size="50" />

  <br /><br />

  <input type="submit" value="Login" />

</form>

</body>
</html>
<%
    Response.End

  End If

%>



