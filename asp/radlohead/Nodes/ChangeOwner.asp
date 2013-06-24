<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  var node = Request.Form('node');

  if ( Request.Form('action') == 'ChangeOwner' ) {

    if ( validUser( Request.Form('nodeOwner'), Request.Form('nodePass') ) ) {

      var objNodes = Server.CreateObject( 'ADODB.RecordSet' );
      var newOwner = new String( Request.Form('newOwner') );
      var changeOwner = true;
      var open = true;

      objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );

      if ( (newOwner.length > 0) && (newOwner != 'null') ) {
        if ( !userExists(newOwner) ) {
          changeOwner = false;
          drawNode( 13, objNodes );
        }
        else open = false;
      }
      else newOwner = '';

      //
      //  try and change the owner
      //

      if ( changeOwner ) {

        objNodes.Find( "id = '" +node+ "'" );

        if ( !objNodes.BOF && !objNodes.EOF ) {        

          objNodes('owner') = newOwner;
          objNodes('open') = open;
          objNodes.Update();
%>

<div class="heading">Owner Changed</div>

<p>
<b>OldOwner:</b> <%= Request.Form('nodeOwner') %><br />
<b>NewOwner:</b> <%= newOwner %>
</p>

<p>
Success!  You have changed the ownership of node <%= node %>.
</p>

<%

        }
        else drawNode( 6 );

      }

    }
    else drawNode( 12 );

  }
  else {
    drawNode( 11 );
  }

%>

<!--#include virtual="/data/inc/Footer.asp"-->