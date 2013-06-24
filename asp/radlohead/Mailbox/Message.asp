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
%>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
 <tr>
  <td class="heading"><%= objMail('title') %></td>
  <td align="right">
   [
    <a href="/Mailbox/Delete.asp?id=<%= objMail('id') %>">Delete</a> |
    <a href="/Mailbox/Reply.asp?id=<%= objMail('id') %>">Reply</a> |
    <a href="/Mailbox/Forward.asp?id=<%= objMail('id') %>">Forward</a>
   ]
  </td>
 </tr>
</table>

<br />
<b>From:</b> <%= objMail('from') %><br />
<b>Sent:</b> <%= new Date( objMail('dateSent')/1 ) %>

<p>
  <%= objMail('message') %>
</p>

<br /><br />

<%

    objMail('read') = true;
    objMail.Update();
    objMail.Close();

  }
  else drawNode( 56 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->