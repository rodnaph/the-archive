
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->

<p>
 <div class="Heading1">&lt; Register &gt;</div>
</p>

<%

  If Request.Form("Action") = "DoRegister" Then

    Dim objComm, objUser, objUsers, error, strName, strEmail, strPass, newUserID

    newUserID = 1
    error = False
    strName = Request.Form("Name")
    strEmail = Request.Form("Email")
    strPass = Request.Form("Password1")

    ' edit params
    strName = Server.HTMLEncode( LTrim( RTrim(strName) ) )

    '
    '  setup command object
    '

    Set objComm = Server.CreateObject( "ADODB.Command" )
    objComm.ActiveConnection = strConnect
    objComm.CommandType = adCmdStoredProc
    objComm.CommandText = "qryUserByName"
    objComm.Parameters.Append( objComm.CreateParameter( "Name", adVarChar, adParamInput, 40, strName ) )

    Set objUser = objComm.Execute

    '
    '  check all ok, if it is then register user
    '

    If Not objUser.EOF Or strName = "" Or strEmail = "" Or strPass = "" Or strPass <> Request.Form("Password2") Then

      error = True

    Else

      Set objUsers = Server.CreateObject( "ADODB.RecordSet" )

      objUsers.Open "Users", strConnect, adOpenDynamic, adLockPessimistic

      '  set user id

      If Not objUsers.EOF Then

        objUsers.MoveLast
        newUserID = objUsers("UserID") + 1

      End If

      '  add new user

      objUsers.AddNew
      objUsers("UserID") = newUserID
      objUsers("Name") = strName
      objUsers("Password") = strPass
      objUsers("Email") = strEmail
      objUsers("DateJoined") = Now
      objUsers("Admin") = False
      objUsers.Update
      objUsers.Close

    End If

    '
    '  give output
    '

    If error Then
%>

<p>
 Sorry, but there was an error registering the username <span class="UserName"><%= strName %></span>, this is for
 one or more of the following reasons.
</p>

<ul>
 <li class="ListBullet">The username is already registered.</li>
 <li class="ListBullet">You missed out a field.</li>
 <li class="ListBullet">Your passwords did not match.</li>
</ul>

<%
    Else
%>

<p>
 Success, you have registered the username <span class="UserName"><%= strName %></span>.  You can access the
 information page for this user <a href="User.asp?UserID=<%= newUserID %>">here</a>.
</p>

<%
    End If

  Else

%>

<p>
 To gain access to the Forum, you must first register a username which you will then
 be known by when you post messages.  To do this just fill in the required details in
 the form below and then hit the register button at the bottom.
</p>

<form method="post" action="Register.asp">

 <input type="hidden" name="Action" value="DoRegister" />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0">
 <tr class="TableHeader">
  <td width="100">
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">User:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input type="text" class="InputText" name="Name" size="85" maxlength="40" value="" tabindex="1" /></td>
 </tr>
 <tr class="TableHeader">
  <td>
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Password:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input type="password" class="InputText" name="Password1" maxlength="40" size="85" tabindex="2" /></td>
 </tr>
 <tr class="TableHeader">
  <td>
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Retype Password:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input type="password" class="InputText" name="Password2" maxlength="40" size="85" tabindex="3" /></td>
 </tr>
 <tr class="TableHeader">
  <td width="105">
   <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
    &nbsp; <span class="TableSubTitle">Email:</span>
   </td></tr></table>
  </td>
  <td> &nbsp; <input class="InputText" type="text" name="Email" size="85" maxlength="40" value="" tabindex="4" /></td>
 </tr>
 <tr class="TableHeader">
  <td colspan="2" align="right">
   <input type="submit" value="Register" tabindex="5" class="InputSubmit" />
   &nbsp;
  </td>
 </tr>
 </table>
</td></tr></table>

</form>

<%

  End If

%>

<!--#include file="Data/Inc/Footer.asp"-->