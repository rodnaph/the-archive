<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/MailboxHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<div class="heading">Inbox</div>

<br />

<%

  var MSG_COUNT = 15;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  // setup command object
  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryMailForUser';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'name', adVarChar, adParamInput, 240, loginName.toUpperCase() ) );

  var objMail = objComm.Execute();
  if ( !objMail.EOF ) objMail.Move( offset );

  // table header
  tableHead( 'Subject', 'From', 'Date Sent' );

  for ( var i=0; (i<MSG_COUNT) && (!objMail.EOF); i++ ) {

    var bgcolor = ( objMail('read') == true ) ? '' : ' bgcolor="#9aaabb"';

%>
 <tr>
  <td<%= bgcolor %>>
   <a href="/Mailbox/Message.asp?id=<%= objMail('id') %>"><%= objMail('title') %></a>
  </td>
  <td align="center"<%= bgcolor %>>
   <a href="/Profiles/ShowProfile.asp?user=<%= Server.URLEncode( objMail('from') ) %>"><%= objMail('from') %></a>
  </td>
  <td align="right"<%= bgcolor %>>
   <%= new Date( objMail('dateSent') / 1 ) %>
  </td>
 </tr>
<%
    objMail.MoveNext();
  }
%>
</table>

<%
  tableLinks( objMail.EOF, MSG_COUNT, '/Mailbox/Default.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->