<%

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  drawReply( objPost )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function drawReply( objPost ) {
%>

  <li><a href="Show.asp?PostID=<%= objPost('PostID') %>"><%= objPost('Subject') %></a>
      - <b><%= objPost('Name') %></b></li>

<%
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  drawReplies( PostID, objPosts )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function drawReplies( ParentID, objPosts ) {

  objPosts.MoveFirst();
  objPosts.Find( 'ParentID = ' +ParentID );

  while ( !objPosts.EOF ) {

    var PostID = objPosts('PostID') / 1;

    Response.Write( '<ul>' );
    drawReply( objPosts );
    drawReplies( PostID, objPosts );
    Response.Write( '</ul>' );

    objPosts.MoveFirst();
    objPosts.Find( 'PostID = ' +PostID );
    objPosts.MoveNext();

    objPosts.Find( 'ParentID = ' +ParentID );

  }

}

%>