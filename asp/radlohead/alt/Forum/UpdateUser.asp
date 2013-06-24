
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<p>
 <div class="Heading1">&lt; Update User &gt;</div>
</p>

<%

  Dim errors

  errors = False

  If Request.Form("Password") = "" Or Request.Form("Email") = "" Then
    errors = True
  End If

%>

<% If Request.Form("Action") = "UpdateUser" And Not errors Then %>

<%

  '  update user details

  Set objUser = Server.CreateObject( "ADODB.RecordSet" )

  objUser.Open "SELECT * FROM Users WHERE Users.Name LIKE '" & Session("Name") & "'", strConnect, adOpenDynamic, adLockPessimistic
  objUser("Password") = Request.Form("Password")
  objUser("Email") = Request.Form("Email")
  objUser.Update
  objUser.Close

%>

<p>
 Success!  <a class="UserName" href="User.asp?UserID=<%= Session("UserID") %>"><%= Session("Name") %></a>
 you have updated your details.  Some changes may take effect straight away, others will
 not be noticed until the next time you log in.
</p>

<% Else %>

<p>
  Sorry, but errors occured while trying to update your account.  This could be for
  one or more of the following reasons.
</p>

<ul>
 <li>You missed out a field.</li>
 <li>Invalid user information was recieved.</li>
</ul>

<% End If %>

<!--#include file="Data/Inc/Footer.asp"-->