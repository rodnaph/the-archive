<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/JournalsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 87 );

  var seen = new Array();
  var objJournals = Server.CreateObject( 'ADODB.RecordSet' );

  objJournals.Open( 'Journals', strConnect );

  tableHead( 'User' );

  while ( !objJournals.EOF ) {
    if ( !seen[objJournals('name')+''] ) {
      seen[objJournals('name')+''] = true;
%> <tr>
  <td>
   &nbsp;
   <b><a href="/Journals/UsersJournals.asp?user=<%= Server.URLEncode(objJournals('username')) %>"><%= objJournals('username') %></a></b><br />
  </td>
 </tr>
<%
    }
    objJournals.MoveNext();
  }

%>
</table>

<!--#include virtual="/Data/Inc/Footer.asp"-->