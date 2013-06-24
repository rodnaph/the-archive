<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/NodesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var NODE_COUNT = 10;
  var user = new String( Request('user') );

  if ( (user.length > 0) && (user != 'undefined') ) {

    var objComm = Server.CreateObject( 'ADODB.Command' );

    objComm.ActiveConnection = strConnect;
    objComm.CommandText = 'qryNodesForUser';
    objComm.CommandType = adCmdStoredProc;
    objComm.Parameters.Append( objComm.CreateParameter( 'Required owner', adVarWChar, adParamInput, 50, user ) );

    var objNodes = objComm.Execute();

    // wind recordset accordingly
    if ( !objNodes.EOF ) objNodes.Move( offset );

%>

<table width="100%">
 <tr>
  <td class="heading">
   Nodes Owned By <a href="/Profiles/ShowProfile.asp?user=<%= Server.URLEncode(user) %>"><%= user %></a>
  </td>
  <td align="right">
   <i>( <%= offset %> - <%= offset + NODE_COUNT %> )</i>
  </td>
 </tr>
</table>

<br />

<%

    tableHead( 'Title', 'Last Updated' );

    for( var i=0; (i<NODE_COUNT) && (!objNodes.EOF); i++ ) {

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

    tableLinks( objNodes.EOF, NODE_COUNT, '/Nodes/UserNodes.asp?user=' +Server.URLEncode(user)+ '&' );

  }
  else drawNode( 42 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->