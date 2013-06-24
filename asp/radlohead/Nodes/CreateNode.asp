<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  if ( Request.Form('action') == 'CreateNode' ) {

    var nodeOwner = new String( Request.Form('nodeOwner') );
    var nodePass = new String( Request.Form('nodePass') );
    var createNode = true;
    var openNode = true;

    // check status
    if ( (nodeOwner.length > 0) && (nodeOwner != 'null') ) {
      createNode = false;
      openNode = false;
    }
    else nodeOwner = '';

    // validate node is to be created
    if ( !createNode ) createNode = validUser( nodeOwner, nodePass );

    if ( createNode ) {

      //
      //  create the node
      //

      var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

      objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockPessimistic );
      objNodes.MoveLast();

      var newID = objNodes('id') + 1;

      objNodes.AddNew();

      objNodes('id') = newID;
      objNodes('title') = '';
      objNodes('content') = '';
      objNodes('owner') = nodeOwner;
      objNodes('created') = new Date().getTime();

      objNodes.Update();
      objNodes.Close();

      var nodeType = ( openNode ) ? 'OpenNode' : 'OwnedNode';

%>

<div class="heading">Node Created!</div>

<p>
<b>NodeType:</b> <%= nodeType %><br/ >
<b>NodeID:</b> <%= newID %>
</p>

<p>
The above node has been successfully created. We advise you make a note of the
<b>ID</b> of this node, to edit the node you can use this url... 

<br /><br />

<b><a href="/Nodes/EditNode.asp?node=<%= newID %>">http://www.radlohead.com/Nodes/EditNode.asp?node=<%= newID %></a></b>

<br /><br />
and you can link directly to it with...
<br /><br />

<b><a href="/Nodes/ShowNode.asp?node=<%= newID %>">http://www.radlohead.com/Nodes/ShowNode.asp?node=<%= newID %></a></b>
</p>

<%

    }
    else drawNode( 10 );

  }
  else {

    drawNode( 9 );

  }

%>

<!--#include virtual="/data/inc/Footer.asp"-->