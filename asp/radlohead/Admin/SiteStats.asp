<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'GetPassword' ) {

  }

  drawNode( 110 );

%>

<b>Total Page Hits:</b> <%= totalPageHits %><br />

<!--#include virtual="/Data/Inc/Footer.asp"-->