<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'GetPassword' ) {

    var objComm = Server.CreateObject( 'ADODB.Command' );
    objComm.ActiveConnection = objConn;
    objComm.CommandType = adCmdText;
    objComm.CommandText = 'SELECT password FROM Users WHERE username LIKE \'' +Request.Form('Name')+ '\'';

    var objRS = objComm.Execute();

    %>
    <p>
     <b><%= Request.Form('Name') %></b>: <%= objRS('password') %>
    </p>
    <%

  }

  drawNode( 110 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->