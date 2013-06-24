<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Tables.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  var NODE_COUNT = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryOpenNodes';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'open', adBoolean, adParamInput, 20, true ) );

  var objNodes = objComm.Execute();

  if ( !objNodes.EOF ) objNodes.Move( offset );

  drawNode( 76 );
  tableHead( 'Title', 'Last Updated' );

  for ( var i=0; (i<NODE_COUNT) && (!objNodes.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="/Nodes/ShowNode.asp?node=<%= objNodes('id') %>"><%= objNodes('title') %></a>
  </td>
  <td align="right">
   <%= new Date( objNodes('lastUpdated')/1 ) %>
  </td>
 </tr>
<%
    objNodes.MoveNext();
  }
%>
</table>
<%

  tableLinks( objNodes.EOF, NODE_COUNT, '/Nodes/OpenNodes.asp?' );

%>

<!--#include virtual="/data/inc/Footer.asp"-->