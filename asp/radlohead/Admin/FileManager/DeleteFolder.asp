<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->
<%

  Dim strPath, objFSO

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )
  strPath = Request.QueryString("Folder")

  objFSO.DeleteFolder( strPath )

%>
<html>
<head>
<title>Folder Deleted</title>
</head>

<body>

<p>
[ <a href="/Admin/FileManager.asp">FileManager</a> ]
</p>

<p>
Folder [<%= strPath %>] was deleted!
</p>

</body>
</html>