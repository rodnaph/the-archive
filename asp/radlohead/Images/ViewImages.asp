<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Tables.asp"-->
<!--#include virtual="/Data/Inc/ImagesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 65 );

  var IMAGE_COUNT = 15;
  var isImages = true;
  var users = new String( Request('users') ).toLowerCase().charAt(0);
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryImagesByUploaded';
  objComm.CommandType = adCmdStoredProc;

  var objImages = objComm.Execute();
  if ( !objImages.EOF ) objImages.Move( offset );
    else isImages = false;

  if ( isImages ) tableHead( 'User', 'Date Uploaded' );
    else drawNode( 89 );

  for ( var i=0; (i<IMAGE_COUNT) && (!objImages.EOF); i++ ) {
%>
 <tr>
  <td>
   <%= objImages('username') %>
  </td>
  <td align="right">
   <%= new Date( objImages('uploaded')/1 ) %>
  </td>
 </tr>
<%
    objImages.MoveNext();
  }

  if ( isImages ) Response.Write( '</table>' );

  tableLinks( objImages.EOF, IMAGE_COUNT, '/Images/ViewImages.asp?users=' +users+ '&' );
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->