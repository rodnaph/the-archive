<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'Contact' ) {

    var objContacts = Server.CreateObject( 'ADODB.RecordSet' );
    var message = new String( Request.Form('Message') );

    message = message.replace( /\n/g, '<br />' );

    objContacts.Open( 'Contacts', strConnect, adOpenDynamic, adLockPessimistic );
    objContacts.AddNew();

    objContacts('From') = Request.Form('Username');
    objContacts('Email') = Request.Form('Email');
    objContacts('Subject') = Request.Form('Subject');
    objContacts('Message') = message;
    objContacts('SentOn') = new Date().getTime();

    objContacts.Update();
    objContacts.Close();

    drawNode( 70 );

  }
  else drawNode( 68 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->