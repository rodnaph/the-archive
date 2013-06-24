<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/ImagesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'UploadImage' ) {

%>
Upload Facility Offline.
<%

  }
  else drawNode( 61 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->