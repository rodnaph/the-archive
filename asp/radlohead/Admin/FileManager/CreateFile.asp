<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->
<%

  Dim objFSO, strPath, objFile

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )

  strPath = Request.Form("Folder") +"\"+ Request.Form("FileName")
  objFSO.CreateTextFile( strPath )

%>
<html>
<head>
<title>FileCreated!</title>
</head>

<body>

<p>
[ <a href="/Admin/FileManager.asp">FileManager</a> ]
</p>

<p>
File [<%= strPath %>] Created!
</p>	

</body>
</html>