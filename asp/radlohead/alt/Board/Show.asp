<%@ language="JScript" @%>

<!--#include file="Data/Inc/Config.asp"-->

<%

  // redirect if needed

  if ( Request('PostID') < 1 ) {

    Response.Redirect( 'Default.asp' );
    Response.End();

  }

  // open database and find post

  var objPosts = Server.CreateObject( 'ADODB.RecordSet' );

  objPosts.Open( 'Posts', strConnect, adOpenDynamic );
  objPosts.Find( 'PostID = ' +Request('PostID') );

  // give output

%>

<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/BoardLib.asp"-->

<p>
 <b><%= objPosts('Subject') %></b>
</p>

<p>
[
 <a href="Default.asp">Board</a> |
 <a href="Show.asp?PostID=<%= objPosts('ParentID') %>">Back Up</a> |
 <a href="#PostForm">Reply</a>
]
</p>

<p>
Posted by <b><%= objPosts('Name') %></b> on <i><%= objPosts('Date') %></i>
</p>

<blockquote><%= objPosts('Message') %></blockquote>

<p>
 <b>Replies</b>
</p>
<%

  // then add replies

  drawReplies( objPosts('PostID')/1, objPosts );

  // finally include form and footer

%>

<!--#include file="Data/Inc/Form.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->