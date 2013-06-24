<html>
<head>

<title>Pics</title>

</head>

<body bgcolor="#ffffff">

<font face="arial" size="-1">

<h3>Pictures</h3>

<%

  Dim objFSO, objFiles, objFile

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )
  Set objFiles = objFSO.GetFolder( Server.MapPath(".") ).Files

  For Each objFile In objFiles
    If objFile.Name <> "Default.asp" Then
      %>
      <p><img src="<%= objFile.Name %>" alt="<%= objFile.Name %>" /></p>
      <%
    End If
  Next

%>

</font>

</body>
</html>