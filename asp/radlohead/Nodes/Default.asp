<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/NodesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 15 );

  //
  //  display the 10 most recently updated nodes
  //

  var NODE_COUNT = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryNodesByUpdated';
  objComm.CommandType = adCmdStoredProc;

  var objNodes = objComm.Execute();
  objNodes.Move( offset );

%>
<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
  <td bgcolor="#cccccc">
   &nbsp;
   <b>Title</b>
  </td>
  <td align="right" bgcolor="#cccccc">
   <b>Last Updated</b>
   &nbsp;
  </td>
 </tr>
<%

  for ( var i=0; (i<NODE_COUNT) && (!objNodes.EOF); i++ ) {
%>
 <tr>
  <td><a href="/Nodes/ShowNode.asp?node=<%= objNodes('id') %>"><%= objNodes('title') %></a></td>
  <td align="right"><%= new Date(objNodes('lastUpdated')/1).toString() %></td>
 </tr>
<%
    objNodes.MoveNext();

  }

%>

</table>

<%

  tableLinks( objNodes.EOF, NODE_COUNT, '/Nodes/Default.asp?' );

%>

<!--#include virtual="/data/inc/Footer.asp"-->