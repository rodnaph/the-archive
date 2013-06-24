<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/MailboxHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'SendMessage' ) {

    if ( userExists( Request.Form('to') ) ) {

      var objMailbox = Server.CreateObject( 'ADODB.RecordSet' );
      var to = new String( Request.Form('to') );
      var message = new String( Request.Form('message') );

      message = message.replace( /\n/g, '<br />' );

      objMailbox.Open( 'Mailbox', strConnect, adOpenDynamic, adLockPessimistic );
      objMailbox.AddNew();

      objMailbox('name') = to.toUpperCase();
      objMailbox('to') = to;
      objMailbox('from') = loginName;
      objMailbox('read') = false;
      objMailbox('dateSent') = new Date().getTime();
      objMailbox('title') = Request.Form('title');
      objMailbox('message') = message;

      objMailbox.Update();
      objMailbox.Close();

      drawNode( 55 );

    }
    else drawNode( 13 );

  }
  else drawNode( 13 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->