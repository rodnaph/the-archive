<!--#include virtual="/Data/Inc/AdminPassword.asp"-->
<%

  var adminPassword = 'radlo';

  if ( Request.Form('Action') == 'AdminLogin' ) {
    if ( Request.Form('Password') == adminPassword ) Session('AdminLogin') = 'Yes';
  }

  if ( Session('AdminLogin') != 'Yes' ) {

%>
<!--#include virtual="/data/inc/Header.asp"-->
<%
  drawNode( 97 );
%>
<!--#include virtual="/data/inc/Footer.asp"-->
<%
  }
%>



