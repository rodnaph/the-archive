<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/LoginHeader.asp"-->
<%

  Session.Abandon();
  Response.Cookies('loginName').Expires = 'July 4, 1990';
  Response.Cookies('loginPass').Expires = 'July 4, 1990';

%>
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  drawNode( 54 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->