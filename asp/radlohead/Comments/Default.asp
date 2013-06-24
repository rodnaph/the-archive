<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/CommentsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var COMMENT_COUNT = 10;

  var node = Request('node');
  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );
  var objComm = Server.CreateObject( 'ADODB.Command' );

  if ( isNaN(node) ) {
    drawNode( 22 );
    %><!--#include virtual="/Data/Inc/Footer.asp"--><%
  }

  // create command object
  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryCommentsForNode';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'Required node', adSmallInt, adParamInput, 50, node ) );

  // get records with command
  var objComments = objComm.Execute();

%>
<div class="heading">Comments For Node <%= node %></div><br />
<%

  // draw node
  drawNode( node );

  // wind comments
  if ( !objComments.EOF ) objComments.Move( offset );

  // draw comments
  var comments = false;
  for ( var i=0; (i<COMMENT_COUNT) && (!objComments.EOF); i++ ) {
%>

<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
  <td bgcolor="#cccccc">&nbsp; <b><%= objComments('title') %></b></td>
  <td align="right" bgcolor="#cccccc"><b><%= objComments('username') %></b> &nbsp;</td>
 </tr>
 <tr>
  <td colspan="2"><table width="100%" cellpadding="5" cellspacing="0" border="0"><tr><td>
   <%= objComments('comment') %>

  </td></tr></table></td>
 </tr>
</table>

<br />

<%
    comments = true;
    objComments.MoveNext();
  }

  tableLinks( objComments.EOF, COMMENT_COUNT, '/Comments/Default.asp?node=' +node+ '&' );

  // cleanup
  objComments.Close();

  //
  //  draw the add comment form for this node
  //

%>

<br /><br />

<div class="heading">Leave Comment</div>

<p>
To leave a comment for <a href="/Nodes/ShowNode.asp?node=<%= node %>"><b>Node <%= node %></b></a> just fill in the form below and click
the submit button.
</p>

<form method="post" action="/Comments/LeaveComment.asp">

  <input type="hidden" name="node" value="<%= node %>" />

  <b>Username:</b> <br />
  <input type="text" name="username" size="50" maxlength="50" />

  <br />

  <b>Password:</b> <br />
  <input type="password" name="password" size="50" maxlength="50" />

  <br /><br />

  <b>Title:</b> <br />
  <input type="text" name="title" size="50" maxlength="50" />

  <br />

  <b>Comment:</b> <br />
  <textarea name="comment" cols="60" rows="10"></textarea>

  <br /><br />

  <b>HTML Help?</b> &nbsp; <input type="checkbox" name="htmlHelp" value="yes" />

  <br /><br />

  <input type="submit" value="Leave Comment on Node <%= node %>" />

</form>

<!--#include virtual="/Data/Inc/Footer.asp"-->