<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/JournalsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 86 );

  var MAX_ENTRIES = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryJournalsByDateLeft';
  objComm.CommandType = adCmdStoredProc;

  var objJournals = objComm.Execute();
  if ( !objJournals.EOF ) objJournals.Move( offset );

  for ( var i=0; (i<MAX_ENTRIES) && (!objJournals.EOF); i++ ) {
%>
<br />
<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
  <td bgcolor="#cccccc">
   <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
    <td>
     &nbsp;
     <b><a href="/Journals/UsersJournals.asp?user=<%= Server.URLEncode(objJournals('username')) %>"><%= objJournals('username') %></a></b>
    </td>
    <td align="right">
     <b><%= new Date( objJournals('dateLeft')/1 ) %></b>
     &nbsp;
    </td>
   </tr></table>
  </td>
 </tr>
 <tr>
  <td>
    <table cellpadding="6" cellspacing="0" border="0"><tr><td>
      <%= objJournals('body') %>
    </td></tr></table>
  </td>
 </tr>
</table>
<%
    objJournals.MoveNext();
  }

  tableLinks( objJournals.EOF, MAX_ENTRIES, '/Journals/NewEntries.asp?' );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->