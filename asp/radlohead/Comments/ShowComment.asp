<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/CommentsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var objComments = Server.CreateObject( 'ADODB.RecordSet' );
  var id = Request('id');

  objComments.Open( 'Comments', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );
  objComments.Find( "id = '" +id+ "'" );

  if ( !objComments.EOF && !objComments.BOF ) {
%>

<div class="heading">Viewing Comment <%= id %></div>

<br />

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

<p>
This comment was left for <a href="/Nodes/ShowNode.asp?node=<%= objComments('node') %>"
><b>Node <%= objComments('node') %></b></a>.
</p>

<%
  }
  else drawNode( 25 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->