<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->
<!--#include virtual="/Data/Inc/JScriptLib.asp"-->

<%

  if ( Request.Form('action') == 'Register' ) {

    var name = trimString( Request.Form('username') );
    var doRegister = true;
    var pass1 = new String( Request.Form('password1') );
    var pass2 = new String( Request.Form('password2') );
    var email = new String( Request.Form('email') );

    // check for valid name
    if ( !validUsername( name ) )
      doRegister = false;

    // check passwords
    if ( ''+pass1 != ''+pass2 )
      doRegister = false;

    // check email
    if ( (email.length == 0) || (email == 'null') )
      doRegister = false;

    // check name not already taken
    var objUsers = Server.CreateObject( 'ADODB.RecordSet' );

    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );
    objUsers.Find( "name = '" +name.toUpperCase()+ "'" );

    if ( !objUsers.EOF && !objUsers.BOF )
      doRegister = false;

    // attempt registration
    if ( doRegister ) {

      objUsers.MoveLast();
      objUsers.AddNew();

      objUsers('name') = name.toUpperCase();
      objUsers('username') = name;
      objUsers('password') = pass1;
      objUsers('hasProfile') = false;
      objUsers('email') = email;

      objUsers.Update();
%>

<div class="heading">Username Registered</div>

<p>
Success!  The following information was added to our database.
</p>

<p>
 <b>Username:</b> <%= name %> <br />
 <b>Password:</b> <i>(hidden)</i> <br />
</p>

<%
      objUsers.Close();

    }
    else drawNode( 18 );

  }
  else drawNode( 17 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->