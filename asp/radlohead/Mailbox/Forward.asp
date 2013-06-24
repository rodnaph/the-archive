<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/MailboxHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var id = Request('id');

  var objMail = Server.CreateObject( 'ADODB.RecordSet' );

  objMail.Open( 'Mailbox', strConnect, adOpenDynamic, adLockOptimistic );
  objMail.Filter = 'name = \'' +loginName.toUpperCase()+ '\' AND id = ' +id;

  if ( !objMail.EOF ) {

    var message = new String( objMail('message') );
    var title = new String( objMail('title') );

    message = message.replace( /\n/g, '' );
    title = 'Fwd: ' +title;

%>

<div class="heading">Forwarding Message</div>

<br />

<b>Title:</b> <%= objMail('title') %> <br />

<br />

<form method="post" action="/Mailbox/SendMessage.asp">

  <input type="hidden" name="action" value="SendMessage" />
  <input type="hidden" name="from" value="<%= loginName %>" />
  <input type="hidden" name="title" value="<%= title %>" />
  <input type="hidden" name="message" value="<%= message %>" />

  <b>Forward To:</b> <br />
  <input type="text" name="to" size="50" maxlength="50" />

  <br /><br />

  <input type="submit" value="Forward Message" />

</form>

<%

  }
  else drawNode( 56 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->