<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  var node = Request('node');

  if ( !isNaN(node) ) {
%>

<div class="heading">Showing Node <%= node %></div>
<br />

<%

    drawNode( node );

  }
  else drawNode( 39 );

%>

<br />

<table width="100%" cellpadding="5" cellspacing="0" border="0">
 <tr>
  <td>
   &nbsp;
   <b><a href="/Nodes/ShowNode.asp?node=<%= (node/1) - 1 %>"><tt>&lt;-</tt> Back</a></b>
  </td>
  <td align="right">
   <b><a href="/Nodes/ShowNode.asp?node=<%= (node/1) + 1 %>">Next <tt>-&gt;</tt></a></b>
   &nbsp;
  </td>
 </tr>
</table>

<!--#include virtual="/data/inc/Footer.asp"-->