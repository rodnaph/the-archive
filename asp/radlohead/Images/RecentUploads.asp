<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/ImagesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 64 );

  var IMAGE_COUNT = 10;

  // setup command object
  var objComm = Server.CreateObject( 'ADODB.Command' );
  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryImagesByUploaded';
  objComm.CommandType = adCmdStoredProc;

  // execute command
  var objImages = objComm.Execute();
  if ( !objImages.EOF ) objImages.Move( offset );

  tableHead( 'User', 'Date Upload' );

  for ( var i=0; (i<IMAGE_COUNT) && (!objImages.EOF); i++ ) {
%>
 <tr>
  <td>
   <a href="/Images/ShowImage.asp?id=<%= objImages('id') %>"><%= objImages('username') %></a>
  </td>
  <td align="right">
   <%= new Date( objImages('uploaded') / 1 ) %>
  </td>
 </tr>
<%
  }

%>
</table>

<%
  tableLinks( objImages.EOF, IMAGE_COUNT, '/Images/RecentUploads.asp?' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->