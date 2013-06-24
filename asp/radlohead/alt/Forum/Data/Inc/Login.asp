
<%

  Dim LoginFail

  loginFail = False

  '
  '  Try and log user in
  '

  If Request.Form("Action") = "DoLogin" Then

    Dim objUser, strName

    strName = Server.HTMLEncode( Request.Form("Name") )

    Set objComm = Server.CreateObject( "ADODB.Command" )
    objComm.ActiveConnection = strConnect
    objComm.CommandText = "qryUserByNameAndPassword"
    objComm.CommandType = adCmdStoredProc
    objComm.Parameters.Append( objComm.CreateParameter( "Name", adVarChar, adParamInput, 40, strName ) )
    objComm.Parameters.Append( objComm.CreateParameter( "Password", adVarChar, adParamInput, 40, Request.Form("Password") ) )

    Set objUser = objComm.Execute

    If Not objUser.EOF Then

      Session("ForumLogin") = "Done"
      Session("Name") = strName
      Session("UserID") = objUser("UserID")
      Session("Admin") = objUser("Admin")

    Else

      loginFail = True

    End If

  End If

  '
  '  Check is user is logged in
  '

  If Session("ForumLogin") <> "Done" Then

%>

<p>
 <div class="Heading1">&lt; Login &gt;</div>
</p>

<p>
 To use the Forum you must be logged in under as a registered user.  If you have registered
 a username then just log in with the form below, otherwise you can register by clicking
 the register link at the top of the screen.
</p>

<form method="post" action="<%= Request.ServerVariables("URL") %>">

  <input type="hidden" name="Action" value="DoLogin" />

<% For Each item In Request.QueryString %>
  <input type="hidden" name="<%= item %>" value="<%= Request.QueryString(item) %>" />
<% Next %>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0">
 <tr class="TableHeader">
  <td width="75">
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">User:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input class="InputText" type="text" name="Name" size="95" maxlength="40" value="" tabindex="1" /></td>
 </tr>
 <tr class="TableHeader">
  <td>
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Password:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input class="InputText" type="password" name="Password" maxlength="40" size="95" tabindex="2" /></td>
 </tr>
 <tr class="TableHeader">
  <td colspan="2" align="right">
   <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
    <td>

<% If loginFail Then %>
  &nbsp;&nbsp; <span class="ErrorMessage">Login Error</span>
<% End If %>

    </td>
    <td align="right">
     <input type="submit" value="Login" tabindex="3" class="InputSubmit" />
    </td>
   </tr></table>
  </td>
 </tr>
 </table>
</td></tr></table>

</form>

<!--#include file="Footer.asp"-->
<%

  End If

%>