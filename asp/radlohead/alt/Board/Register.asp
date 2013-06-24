<%@ language="JScript" @%>

<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Links.asp"-->

<p>
 <b>Board Registration</b>
</p>

<%

  if ( Request.Form('Action') == 'Register' ) {

    // check fields are present
    if ( (Request.Form('Name') == '') ||
         (Request.Form('Password1') == '') ||
         (Request.Form('Password1') != Request.Form('Password2')+'') ) error();

    // check user doesn't exist
    var objComm = Server.CreateObject( 'ADODB.Command' );
    objComm.ActiveConnection = strConnect;
    objComm.CommandText = 'qryUserByName';
    objComm.CommandType = adCmdStoredProc;
    objComm.Parameters.Append( objComm.CreateParameter( 'Name', adVarChar, adParamInput, 60, Request.Form('Name') ) );

    var objUser = objComm.Execute();

    if ( !objUser.EOF ) error();

    var objUsers = Server.CreateObject( 'ADODB.RecordSet' );
    var UserID = 1;

    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockPessimistic );
 
    if ( !objUsers.EOF ) {
      objUsers.MoveLast();
      UserID = objUsers('UserID') + 1;
    }

    objUsers.AddNew();
    objUsers('UserID') = UserID;
    objUsers('Name') = Request.Form('Name');
    objUsers('Password') = Request.Form('Password1');
    objUsers('Email') = Request.Form('Email');
    objUsers.Update();
    objUsers.Close();

%>

<p>
[
 <a href="Default.asp">Board</a> |
 <a href="Default.asp#PostForm">Post Message</a>
]
</p>

<p>
Success!  <b><%= Request.Form('Name') %></b>, you have registered this username.  You
will now be able to post under this name on the message board.
</p>

<%

  }
  else {
%>

<p>
 To register a name, just fill in the form below and hit the register button.
</p>

<form method="post" action="Register.asp">

  <input type="hidden" name="Action" value="Register" />

  <b>Name</b><br />
  <input type="text" name="Name" size="58" maxlength="60" value="" />

  <br />

  <b>Password</b><br />
  <input type="password" name="Password1" size="58" maxlength="60" value="" />

  <br />

  <b>Re-type Password</b><br />
  <input type="password" name="Password2" size="58" maxlength="60" value="" />

  <br />

  <b>Email</b><br />
  <input type="text" name="Email" size="58" maxlength="60" value="" />

  <br /><br />

  <input type="submit" value="Register" />

</form>

<%
  }

  function error() {
%>

<!--#include file="Data/Inc/RegisterError.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->

<%
  }

%>

<!--#include file="Data/Inc/Footer.asp"-->