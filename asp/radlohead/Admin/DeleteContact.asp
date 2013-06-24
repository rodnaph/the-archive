<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var id = Request('id');
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryDeleteContact';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'ID', adSmallInt, adParamInput, 20, id ) );
  objComm.Execute();

  drawNode( 72 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->