<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/NodesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 21 );

  var NODE_COUNT = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryNodesByCreated';
  objComm.CommandType = adCmdStoredProc;

  var objNodes = objComm.Execute();
  objNodes.Move( offset );

  tableHead( 'Title', 'Created' );

  for ( var i=0; (i<NODE_COUNT) && (!objNodes.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="/Nodes/ShowNode.asp?node=<%= objNodes('id') %>"><%= objNodes('title') %></a>
  </td>
  <td align="right">
   <%= new Date( objNodes('created') / 1 ) %>
  </td>
 </tr>
<%
    objNodes.MoveNext();
  }

%>
</table>

<%

  tableLinks( objNodes.EOF, NODE_COUNT, '/Nodes/NewNodes.asp?' );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->