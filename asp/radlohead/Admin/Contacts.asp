<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<div class="heading">Contacts</div><br />

<%

  var MSG_COUNT = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryContactsBySent';
  objComm.CommandType = adCmdStoredProc;

  var objContacts = objComm.Execute();

  // wind
  if ( !objContacts.EOF ) objContacts.Move( offset );

  tableHead( 'Subject', 'Sent On' );

  // draw rows
  for ( var i=0; (i<MSG_COUNT) && (!objContacts.EOF); i++ ) {
%>
 <tr>
  <td><a href="/Admin/ViewContact.asp?id=<%= objContacts('ID') %>"><%= objContacts('Subject') %></a></td>
  <td align="right"><%= new Date( objContacts('SentOn')/1 ) %></td>
 </tr>
<%
    objContacts.MoveNext();
  }

%>

</table>

<%

  tableLinks( objContacts.EOF, MSG_COUNT, '/Admin/Contacts.asp?' );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->