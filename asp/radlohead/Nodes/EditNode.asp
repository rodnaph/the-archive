<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->
<!--#include virtual="/data/inc/Nodes.asp"-->
<!--#include virtual="/data/inc/Users.asp"-->
<!--#include virtual="/data/inc/NodesHeader.asp"-->
<!--#include virtual="/data/inc/Header.asp"-->

<%

  var updated = false;
  var pass = '';

  //
  //  updateNode()
  //

  function updateNode( id, title, content, htmlHelp, objNodes ) {

    var doClose = false;

    content = new String( content );

    // link nodes
    var re = /\{\{(\d+)\}\}/;
    while ( content.match(re) )
      content = content.replace( re, '<a href="/Nodes/ShowNode.asp?node='
                                   +RegExp.$1+ '">Node '+RegExp.$1+ '</a>' );

    // give html help if needed
    if ( htmlHelp )
      content = content.replace( /\n/g, '<br />' );

    // open db if no active connection
    if ( objNodes == null ) {
      doClose = true;
      objNodes = Server.CreateObject( 'ADODB.RecordSet' );
      objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );
    }

    objNodes.Find( "id = '" +id+ "'" );

    var owner = new String( objNodes('owner') );
    var open = ( (owner.length>0) && (owner!='null') ) ? false : true;

    objNodes('title') = title;
    objNodes('content') = content;
    objNodes('htmlHelp') = htmlHelp;
    objNodes('lastUpdated') = new Date().getTime();
    objNodes('open') = open;

    objNodes.Update();

    if ( doClose )
      objNodes.Close();

  }

  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );
  var node = Request('node');

  objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  //
  //  try updating node
  //

  if ( Request.Form('action') == 'UpdateNode' ) {

    objNodes.Find( "id = '" +node+ "'" );

    var owner = new String( objNodes('owner') );
    var htmlHelp = ( Request.Form('htmlHelp') == 'yes' ) ? true : false;
    var doUpdate = false;

    if ( (owner.length > 0) && (owner != 'null') ) {

      // validate user
      var password = Request.Form('password');
      var objUsers = Server.CreateObject( 'ADODB.RecordSet' );

      objUsers.Open( 'Users', strConnect, adOpenDynamic );
      objUsers.Find( "name = '" +owner.toUpperCase()+ "'" );

      if ( !objUsers.EOF && !objUsers.BOF ) {
        if ( ''+objUsers('password') == password )
          doUpdate = true;
      }

      objUsers.Close();

    }
    else doUpdate = true;

    if ( doUpdate ) {
      updateNode( node, Request.Form('nodeTitle'), Request.Form('nodeContent'), htmlHelp, objNodes );
      drawNode( 44 );
      updated = true;
     }
     else drawNode( 7 );

  }

  //
  //  draw rest of page
  //

  if ( !isNaN(node) ) {

    objNodes.Find( "id = '" +node+ "'" );

    if ( !objNodes.BOF && !objNodes.EOF ) {

      var owner = new String( objNodes('owner') );
      var content = new String( objNodes('content') );

      // try setting password
      if ( updated ) pass = Request.Form('password')
      else if ( (Session('loggedIn') == true) && (Session('loginName')+'' == owner) )
             pass = Session('loginPass');

      owner = ( (owner != 'null') || (owner.length==0) ) ? owner : '<i>(No Password Needed)</i>';

      // give html help
      if ( objNodes('htmlHelp') == true )
        content = content.replace( /<br \/>/g, "\n" );

      // encode illegal chars
      content = Server.HTMLEncode( content );

%>

<div class="heading"><a href="/Nodes/ShowNode.asp?node=<%= node %>">Editing Node <%= node %></a></div>

<p>
To edit the current node, just change the relevant text, then click the update button. If
you check the <b>HTML Help</b> box then line breaks will be inserted automatically for you.
If the node is owned by somone then you will need to enter the correct password before you
are allowed to edit that node.
<b>You may have to refresh before changes are visible.</b>
</p>

<p>
<b>Owner:</b> <%= owner %>
</p>

<form method="post" action="EditNode.asp">

  <input type="hidden" name="action" value="UpdateNode" />
  <input type="hidden" name="node" value="<%= node %>" />

  <b>Password:</b> <i>(only needed for owned nodes)</i> <br />
  <input type="password" name="password" size="50" maxlength="50" value="<%= pass %>" />

  <br /><br />

  <b>Title:</b><br />
  <input type="text" name="nodeTitle" size="50" maxlength="50" value="<%= objNodes('title') %>" />

  <br /><br />

  <b>Content:</b><br />
  <textarea name="nodeContent" cols="70" rows="15"><%= content %></textarea>

  <br /><br />

  <b>HTML Help?</b> &nbsp; <input type="checkbox" name="htmlHelp" value="yes" />

  <br /><br />

  <input type="submit" value="Update Node <%= node %>" />

</form>

<%
    }
    else drawNode( 6 );

  }

  drawNode( 5 );

%>

<!--#include virtual="/data/inc/Footer.asp"-->