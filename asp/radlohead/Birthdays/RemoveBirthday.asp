<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/BirthdaysHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

  objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockReadOnly );

  if ( Request.Form('action') == 'RemoveBirthday' ) {

    var username = new String( Request.Form('username') );

    if ( validUser( username, Request.Form('password') ) ) {

      var objBirthdays = Server.CreateObject( 'ADODB.RecordSet' );

      objBirthdays.Open( 'Birthdays', strConnect, adOpenDynamic, adLockPessimistic );
      objBirthdays.Find( "name = '" +username.toUpperCase()+ "'" );

      if ( !objBirthdays.EOF ) {

        drawNode( 37, objNodes );

        objBirthdays.Delete();
        objBirthdays.Update();
        objBirthdays.Close();

      }
      else drawNode( 36, objNodes );

    }
    else drawNode( 12, objNodes );

  }
  else drawNode( 35, objNodes );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->