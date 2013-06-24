<%@ language="JScript" @%>

<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->

<%

  //  check user is valid

  var UserID = -1;
  var objComm = Server.CreateObject( 'ADODB.Command' );
  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryUserByNameAndPassword';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'Name', adVarChar, adParamInput, 60, Request.Form('Name') ) );
  objComm.Parameters.Append( objComm.CreateParameter( 'Name', adVarChar, adParamInput, 60, Request.Form('Password') ) );

  var objUser = objComm.Execute();

  if ( objUser.EOF ) {

%>

<!--#include file="Data/Inc/PostError.asp"-->
<!--#include file="Data/Inc/Footer.asp"-->

<%

    Response.End();
  }
  else UserID = objUser('UserID');

  function editParam( param ) {

    var str = new String( param );
    var swaps = new Array(
                           new Array( '<', '&lt;' ),
                           new Array( '>', '&gt;' ),
                           new Array( '"', '&quot;' )
                         );

    for ( var i in swaps ) {

      var swap = swaps[i];

      str = str.replace( new RegExp( swap[0], 'g' ), swap[1] );

    }

    return str;

  }

  var objPosts = Server.CreateObject( 'ADODB.RecordSet' );
  var MAX_POSTS = 1000;
  var newPostID = 1;
  var strName = Request.Form('Name');
  var strSubject = Request.Form('Subject');
  var strMessage = new String( Request.Form('Message') );

  objPosts.Open( 'Posts', strConnect, adOpenDynamic, adLockPessimistic );

  // set ID of new post

  if ( !objPosts.EOF ) {

    objPosts.MoveLast();
    newPostID = objPosts('PostID') + 1;

    if ( newPostID > MAX_POSTS )
      newPostID = 1;

  }

  // edit parameters

  strName = editParam( strName );
  strSubject = editParam( strSubject );
  strMessage = strMessage.replace( /\n/g, '<br />' );

  // add new post to database

  objPosts.Find( 'PostID = ' +newPostID );

  if ( objPosts.EOF )
    objPosts.AddNew();

  objPosts('PostID') = newPostID;
  objPosts('ParentID') = ( Request.Form('Action') == 'Thread' ) ? -1 : Request.Form('ParentID');
  objPosts('Name') = strName;
  objPosts('Subject') = strSubject;
  objPosts('Message') = strMessage;
  objPosts('Date') = new Date();
  objPosts('UserID') = UserID;

  objPosts.Update();
  objPosts.Close();

  // give output

%>

<p>
 <b><%= strSubject %></b>
</p>

<p>
[
 <a href="Default.asp">Board</a> |
 <a href="Show.asp?PostID=<%= newPostID %>">Your Post</a>
]
</p>

<p>

 <b><%= strName %></b>, your message with the following content has been posted.

</p>

  <blockquote><%= strMessage %></blockquote>

<!--#include file="Data/Inc/Footer.asp"-->