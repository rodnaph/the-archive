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

    var title = new String( objMail('title') );
    var message = new String( objMail('message') );

    title = 'Re: ' +title;
    message = message.replace( /<br \/>/g, '\n' );

%>

<div class="heading">Replying to <%= objMail('from') %></div>

<br />

<form method="post" action="/Mailbox/SendMessage.asp">

  <input type="hidden" name="action" value="SendMessage" />
  <input type="hidden" name="to" value="<%= objMail('from') %>" />

  <b>Subject:</b> <br />
  <input type="text" name="title" size="50" maxlength="50" value="<%= title %>" />

  <br />

  <b>Message:</b> <br />
  <textarea name="message" cols="50" rows="10"><%= message %></textarea>

  <br /><br />

  <input type="submit" value="Send Reply" />

</form>

<%
  }
  else drawNode( 56 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->