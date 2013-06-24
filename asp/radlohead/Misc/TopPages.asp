<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 78 );

  var MAX_PAGES = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryTopPages';
  objComm.CommandType = adCmdStoredProc;

  var objPages = objComm.Execute();
  if ( !objPages.EOF ) objPages.Move( offset );

  tableHead( 'Page', 'No. Of Visits' );

  for ( var i=0; (i<MAX_PAGES) && (!objPages.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="<%= objPages('url') %>"><%= objPages('url') %></a>
  </td>
  <td align="right">
   <%= objPages('hits') %>
  </td>
 </tr>
<%
    objPages.MoveNext();
  }

%>
</table>
<%
  tableLinks( objPages.EOF, MAX_PAGES, '/Misc/TopPages.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->