<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->
<%

  Dim strPath, objFSO

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )
  strPath = Request.QueryString("File")

  objFSO.DeleteFile( strPath )

%>
<html>
<head>
<title>File Deleted</title>
</head>

<body>

<p>
[ <a href="/Admin/FileManager.asp">FileManager</a> ]
</p>

<p>
File [<%= strPath %>] was deleted!
</p>

</body>
</html>