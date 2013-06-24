<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'DeleteUsername' ) {

    var objUsers = Server.CreateObject( 'ADODB.RecordSet' );
    var name = new String( Request.Form('username') );

    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );

    if ( validUser( name, Request.Form('password'), objUsers ) ) {

      // delete record from db
      objUsers.Find( "name = '" +name.toUpperCase()+ "'" );
      objUsers.Delete();
      objUsers.Update();
      objUsers.Close();

%>

<div class="heading"><%= name %> Deleted</div>

<p>
Success, the username <b><%= name %></b> has been removed from the system.  It is
now available for anyone else to register.
</p>

<%

    }
    else drawNode( 12 );

  }
  else drawNode( 19 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->