<%

var offset = ( isNaN(Request('offset')) || ( (Request('offset')/1) < 0) ) ? 0 : Request('offset') / 1;

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  tableLinks()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function tableLinks( noMoreRecords, MAX, link ) {

  if ( (offset > 0) || (!noMoreRecords) ) {
%>

<br />

<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#cccccc">
<tr><td>
 <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
   <td>
   &nbsp;
   <b>
<%
    if ( offset > 0 ) {
%>
 <a href="<%= link %>offset=<%= offset - MAX %>"><tt>&lt;-</tt> Back</a>
<%
    }
%>
   </b>
   </td>
   <td align="right">
   <b>
<%
    if ( !noMoreRecords ) {
%>
  <a href="<%= link %>offset=<%= offset + MAX %>">More <tt>-&gt;</tt></a>
<%
    }
%>
   </b>
   &nbsp;
   </td>
  </tr>
 </table>
</td></tr></table>

<%

  }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  tableHead( [, fields] )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function tableHead() {

%>
<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
<%

  for ( var i=0; i<arguments.length; i++ ) {

    var align = 'center';

    if (i == arguments.length-1) align = 'right';
      else if ( i == 0 ) align = 'left';

%>
  <td bgcolor="#cccccc" align="<%= align %>">
   &nbsp;
   <b><%= arguments[i] %></b>
   &nbsp;
  </td>
<%
  }
%>
 </tr>
<%

}

%>