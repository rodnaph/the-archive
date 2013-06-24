<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/JournalsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'LeaveEntry' ) {

    var user = new String( Request.Form('username') );

    if ( validUser( user, Request.Form('password') ) ) {

      // all ok, add entry
      var objJournals = Server.CreateObject( 'ADODB.RecordSet' );
      var body = new String( Request.Form('body') );

      objJournals.Open( 'Journals', strConnect, adOpenDynamic, adLockPessimistic );
      objJournals.AddNew();
      objJournals('name') = user.toUpperCase();
      objJournals('username') = user;
      objJournals('body') = body.replace( /\n/g, '<br />' );
      objJournals('dateLeft') = new Date().getTime();
      objJournals.Update();
      objJournals.Close();

      drawNode( 85 );

    }
    else drawNode( 12 );

  }
  else drawNode( 84 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->