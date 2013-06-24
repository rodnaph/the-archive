<%@ language="jscript" @%>
<%

  Response.ContentType = 'text/jpeg';

  var url = Request('url');
  var objFSO = Server.CreateObject( 'Scripting.FileSystemObject' );
  var objFile = objFSO.GetFile( 'd:/sites/asprad/' +url );
  var objIn = objFile.OpenAsTextStream();

  while ( !objIn.AtEndOfStream ) {

    Response.Write( objIn.ReadLine() );

  }

%>
