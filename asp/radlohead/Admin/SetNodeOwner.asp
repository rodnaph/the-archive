<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'SetNodeOwner' ) {

    var objNodes = Server.CreateObject( 'ADODB.RecordSet' );
    var node = Request.Form( 'NodeID' );

    objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockPessimistic );
    objNodes.Find( 'id = ' +node );

    if ( !objNodes.EOF && !objNodes.BOF ) {

      objNodes('owner') = Request.Form( 'NewOwner' );
      objNodes.Update();
      objNodes.Close();

      drawNode( 101 );

    }
    else drawNode( 6 );

  }
  else drawNode( 100 );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->