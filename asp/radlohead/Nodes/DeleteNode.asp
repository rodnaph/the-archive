<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'DeleteNode' ) {

    var node = (isNaN(Request.Form('node'))) ? -1 : Request.Form('node');

    if ( validUser( Request.Form('nodeOwner'), Request.Form('nodePass') ) ) {

      var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

      objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );
      objNodes.Find( "id = '" +node+ "'" );

      if ( !objNodes.EOF && !objNodes.BOF ) {

        objNodes.Delete();
        objNodes.Update();
%>

<div class="heading">Node Deleted</div>

<%

      }
      else drawNode( 6 );

    }
    else drawNode( 12 );

  }
  else drawNode( 14 );

%>

<!--#include virtual="/data/inc/Footer.asp"-->