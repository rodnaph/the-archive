<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/JournalsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var MAX_ENTRIES = 10;
  var user = new String( Request('user') );
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryJournalsByUser';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'name', adVarChar, adParamInput, 50, user.toUpperCase() ) );

  var objJournals = objComm.Execute();
  if ( !objJournals.EOF ) objJournals.Move( offset );

  if ( !objJournals.EOF ) {
%>
<div class="heading">Journals For <%= user %></div>
<%

    for ( var i=0; (i<MAX_ENTRIES) && (!objJournals.EOF); i++ ) {
%>
<br />
<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
  <td bgcolor="#cccccc" align="right">
   &nbsp;
   <b><%= new Date( objJournals('dateLeft')/1 ) %></b>
   &nbsp;
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

    tableLinks( objJournals.EOF, MAX_ENTRIES, '/Journals/UsersJournals.asp?user=' +Server.URLEncode(user)+ '&' );

  }
  else {

    if ( (user.length > 0) && (user!='undefined') )
      drawNode( 83 );

    drawNode( 82 );

  }

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->