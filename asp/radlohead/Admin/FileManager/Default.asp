<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->

<%

  Dim objFSO, objFiles, objFolders, dir

  dir = Request.QueryString("Folder")

  If ( dir = "" ) Then
    dir = Server.MapPath( "../../" )
  End If

  Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )

%>
<html>
<head>
<title>FileManager</title>
</head>

<body>

<%

  Dim strBack, objFolder

  Set objFolder = objFSO.GetFolder( dir )
  If Not objFolder.IsRootFolder Then
    Set objFolder = objFolder.ParentFolder
  End If
  strBack = "/Admin/FileManager/Default.asp?Folder=" +Server.URLEncode(objFolder.Path)

  

%>

<p>
[ <a href="<%= strBack %>">Up Folder</a> ]
</p>


<table width="100%" border="0" cellspacing="0" cellpadding="3">
<%


  ' draw folders
  Set objFolders = objFSO.GetFolder( dir ).SubFolders

  For Each objFolder In objFolders
%>
 <tr>
  <td>
   <a href="DeleteFolder.asp?Folder=<%= Server.URLEncode(objFolder.Path) %>"><img src="/Data/Images/delete.gif" border="0" /></a>
   <img src="/Data/Images/folder.gif" /> &nbsp;
   <a href="Default.asp?Folder=<%= Server.UrlEncode(objFolder.Path) %>"><%= objFolder.Name %></a>
  </td>
 </tr>
<%
  Next

  ' draw files

  Set objFiles = objFSO.GetFolder( dir ).Files

  For Each objFile In objFiles
%>
 <tr>
  <td>
   <a href="DeleteFile.asp?File=<%= Server.URLEncode(objFile.Path) %>"><img src="/Data/Images/delete.gif" border="0" /></a>
   <img src="/Data/Images/file.gif" /> &nbsp;
   <a href="EditPage.asp?Folder=<%= Server.URLEncode(strFolder) %>&File=<%= Server.URLEncode(objFile.Path) %>"><%= objFile.Name %><br /></a>
  </td>
 </tr>
<%
  Next

%>
</table>

<p><hr></p>

<table>
 <tr>
  <td valign="top">

<form method="post" action="CreateFile.asp">

  <input type="hidden" name="Folder" value="<%= dir %>" />

  <b>Create File:</b> &nbsp;
  <input type="text" name="FileName" size="25" maxlength="60" />

  </td>
  <td>

  <input type="submit" value="Create File" />

</form>

  </td>
 </tr>
 <tr>
  <td valign="top">

<form method="post" action="/Admin/CreateFolder.asp">

  <input type="hidden" name="Folder" value="<%= dir %>" />

  <b>Create Folder:</b> &nbsp;
  <input type="text" name="FolderName" size="25" maxlength="60" />

  </td>
  <td>

  <input type="submit" value="Create Folder" />

</form>

  </td>
 </tr>
</table>

</body>
</html>