<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/CommentsHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var node = Request.Form('node') / 1;
  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

  objNodes.Open( 'Nodes', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  drawNode( node, objNodes );

  if ( validUser( Request.Form('username'), Request.Form('password') ) ) {

    if ( !isNaN(node) ) {

      var htmlHelp = ( ''+Request.Form('htmlHelp') == 'yes' ) ? true : false;
      var comments = new String( Request.Form('comment') );
      var objComments = Server.CreateObject( 'ADODB.RecordSet' );

      if ( htmlHelp )
        comments = comments.replace( /\n/g, '<br />' );

      objComments.Open( 'Comments', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );
      objComments.AddNew();

      objComments('node') = node;
      objComments('title') = Request.Form('title');
      objComments('comment') = comments;
      objComments('username') = Request.Form('username');
      objComments('leftOn') = new Date().getTime();

      objComments.Update();
%>

<div class="heading">Comment Added</div>

<p>
<%= Request.Form('username') %>, your comment on <b>Node <%= node %></b> has been added.
</p>

<p>
 <b>Title:</b> &nbsp; <%= Request.Form('title') %> <br />
 <b>Comment:</b>
  <blockquote>
   <%= comments %>
  </blockquote>
</p>

<%
      objComments.Close();

    }
    else drawNode( 6, objNodes );

  }
  else drawNode( 12, objNodes );

%>
<!--#include virtual="/Data/Inc/Footer.inc"-->