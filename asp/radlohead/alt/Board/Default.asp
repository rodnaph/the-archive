<%@ language="JScript" @%>

<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/BoardLib.asp"-->

<!--#include file="Data/Inc/Links.asp"-->

<p>
 <b>Board</b>
</p>

<p>
  This is the message board.... enjoy...
</p>

<%

  var objPosts = Server.CreateObject( 'ADODB.RecordSet' );
  var MAX_THREADS = 40;
  var threadCount = 1;

  objPosts.Open( 'Posts', strConnect, adOpenDynamic );
  if ( !objPosts.EOF ) objPosts.MoveLast();

  while ( !objPosts.BOF && (threadCount < MAX_THREADS) ) {

    if ( objPosts('ParentID') < 1 ) {
%>

<ul>

<%

      var PostID = objPosts('PostID') / 1;

      drawReply( objPosts );
      drawReplies( PostID, objPosts );

      objPosts.MoveFirst();
      objPosts.Find( 'PostID = ' +PostID );

%>

</ul>

<%
    }

    objPosts.MovePrevious();
    threadCount++;

  }

  objPosts.Close();

%>

<!--#include file="Data/Inc/Form.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->