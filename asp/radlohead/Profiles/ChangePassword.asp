<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'ChangePassword' ) {

    var objUsers = Server.CreateObject( 'ADODB.RecordSet' );
    var user = new String( Request.Form('username') );

    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockPessimistic );

    if ( validUser( user, Request.Form('password'), objUsers ) ) {

      var newPass = new String( Request.Form('newPass1') );

      if ( (newPass == ''+Request.Form('newPass2')) && (newPass.length > 0) ) {

        objUsers.Find( 'name = \'' +user.toUpperCase()+ '\'' );
        objUsers('password') = newPass;
        objUsers.Update();
        objUsers.Close();

%>

<div class="heading">Password Changed</div>

<p>
Success, <%= user %> you have changed your password.
</p>

<%
      }
      else drawNode( 51 );

    }
    else drawNode( 12 );

  }
  else drawNode( 50 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->