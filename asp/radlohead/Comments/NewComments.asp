<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/CommentsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 24 );

  var COMMENT_COUNT = 10;
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryCommentsByLeftOn';
  objComm.CommandType = adCmdStoredProc;

  var objComments = objComm.Execute();
  objComments.Move( offset );

  tableHead( 'Title', 'Left On' );

  for ( var i=0; (i<COMMENT_COUNT) && (!objComments.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="/Comments/ShowComment.asp?id=<%= objComments('id') %>"><%= objComments('title') %></a>
  </td>
  <td align="right">
   <%= new Date( objComments('leftOn')/1 ) %>
  </td>
 </tr>
<%
    objComments.MoveNext();
  }

%>
</table>

<%
  tableLinks( objComments.EOF, COMMENT_COUNT, '/Comments/NewComments.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->