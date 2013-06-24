<%

// sets global node object
var objGlobNodes = Server.CreateObject( 'ADODB.RecordSet' );
objGlobNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockReadOnly );

//////////////////////////////////////////////////////////////////////////////////////////
//
//  drawNodes( [ id, ] )
//
//////////////////////////////////////////////////////////////////////////////////////////

function drawNodes() {

  for ( var i=0; i<arguments.length; i++ )
    drawNode( arguments[i] )

}

//////////////////////////////////////////////////////////////////////////////////////////
//
//  drawNode( id )
//
//////////////////////////////////////////////////////////////////////////////////////////

function drawNode( id  ) {

  objGlobNodes.MoveFirst();
  objGlobNodes.Find( "id = '" +id+ "'" );

  if ( !objGlobNodes.EOF && !objGlobNodes.BOF ) {

    var tabColor = '#aa9999';
    var content = new String( objGlobNodes('content') );
    var color = ( objGlobNodes('open') == true ) ? '#99aa99' : '#8899aa';
    var nodeLink = ( objGlobNodes('open') == true ) ?  '' : '<a href="/Profiles/ShowProfile.asp?user=' +Server.URLEncode( objGlobNodes('owner') )+ '">' +objGlobNodes('owner')+ '</a>';

%>

<!-- start node <%= id %> -->

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#000000"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0"><tr bgcolor="#aaaaaa"><td>

  <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr bgcolor="<%= color %>">
   <td>

    &nbsp;
    <%= nodeLink %>

   </td>
   <td align="right">

    <b><a href="/Nodes/ShowNode.asp?node=<%= id %>"><%= objGlobNodes('title') %></a></b>
    &nbsp;

   </td>
  </tr></table>
  <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
   <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr></table>
  <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>

   <%= content %>

  </td></tr></table>

 </td></tr></table>
</td></tr></table>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td align="right">

 <table cellpadding="0" cellspacing="0" border="0"><tr>

  <!-- comment -->

  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td bgcolor="<%= tabColor %>">
   &nbsp; <a href="/Comments/Default.asp?node=<%= id %>"><font color="#222222">Comment</font></a> &nbsp;
  </td>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td><img src="/Data/Images/spacer.gif" width="4" height="4" alt="" /></td>

  <!-- edit -->

  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td bgcolor="<%= tabColor %>">
   &nbsp; <a href="/Nodes/EditNode.asp?node=<%= id %>"><font color="#222222">Edit Node</font></a> &nbsp;
  </td>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td><img src="/Data/Images/spacer.gif" width="8" height="8" alt="" /></td>

 </tr><tr>

  <!-- comment bottom -->

  <td colspan="3" bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td></td>

  <!-- edit bottom -->

  <td colspan="3" bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td></td>

 </tr></table>

</td></tr></table>

<br />

<!-- end node <%= id %> -->

<%

  }
  else {
%>
<p><b>ERROR:</b>  Node <%= id %> not found in DB</p>
<%
  }

  objGlobNodes.MoveFirst();

}

%>
