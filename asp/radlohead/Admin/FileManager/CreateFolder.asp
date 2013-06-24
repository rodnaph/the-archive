<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->
<%

  Dim objFSO, strPath, objFile

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )

  strPath = Request.Form("Folder") +"\"+ Request.Form("FolderName")
  objFSO.CreateFolder( strPath )

%>
<html>
<head>
<title>Folder Created!</title>
</head>

<body>

<p>
[ <a href="/Admin/FileManager.asp">FileManager</a> ]
</p>

<p>
Folder [<%= strPath %>] Created!
</p>	

</body>
</html>