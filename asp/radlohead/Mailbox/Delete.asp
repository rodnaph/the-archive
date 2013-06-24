<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/MailboxHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var id = Request('id');

  if ( !isNaN(id) ) {

    var objMail = Server.CreateObject( 'ADODB.RecordSet' );

    objMail.Open( 'Mailbox', strConnect, adOpenDynamic, adLockOptimistic );
    objMail.Filter = 'name = \'' +loginName.toUpperCase()+ '\' AND id = ' +id;

    if ( !objMail.EOF ) {

      objMail.Delete();
      objMail.Update();
      objMail.Close();

      drawNode( 57 );

    }
    else drawNode( 56 );

  }
  else drawNode( 73 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->