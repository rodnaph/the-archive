<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 27 );

  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryProfilesByUpdated';
  objComm.CommandType = adCmdStoredProc;

  var PROFILE_COUNT = 20;
  var objProfiles = objComm.Execute();

  if ( !objProfiles.EOF ) objProfiles.Move( offset );

  tableHead( 'Username', 'Last Updated' );

  for ( var i=0; (i<PROFILE_COUNT) && (!objProfiles.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="javascript:showProfileWin('<%= Server.URLEncode(objProfiles('username')) %>')"><%= objProfiles('username') %></a>
  </td>
  <td align="right">
   <%= new Date( objProfiles('lastUpdated')/1 ) %>
  </td>
 </tr>
<%
    objProfiles.MoveNext();
  }

%>
</table>
<%
  tableLinks( objProfiles.EOF, PROFILE_COUNT, 'Updated.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->
