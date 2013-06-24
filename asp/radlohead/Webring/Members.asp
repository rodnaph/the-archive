<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/WebringHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 49 );

  var SITE_COUNT = 10;

  // setup command object
  var objComm = Server.CreateObject( 'ADODB.Command' );
  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryWebringByAdded';
  objComm.CommandType = adCmdStoredProc;

  var objWebring = objComm.Execute();

  // wind
  objWebring.Move( offset );

  tableHead( 'URL', 'Date Added' );

  for ( var i=0; (i<SITE_COUNT) && (!objWebring.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="<%= objWebring('url') %>" target="_blank"><%= objWebring('url') %></a>
  </td>
  <td align="right">
   <%= new Date( objWebring('dateAdded') / 1 ) %>
  </td>
 </tr>
<%
    objWebring.MoveNext();
  }

%>
</table>

<%
  tableLinks( objWebring.EOF, SITE_COUNT, '/Webring/Members.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->