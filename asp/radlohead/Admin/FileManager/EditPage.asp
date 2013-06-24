<!--#include virtual="/Data/Inc/FileManagerHeader.asp"-->

<html>
<head>
<title>Editing A Page</title>
</head>

<body>

<%

  page = Request( "File" )

  ' do update
  If Request.Form("Action") = "UpdatePage" Then

    Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )
    Set objFile = objFSO.GetFile( page )
    Set objOut = objFile.OpenAsTextStream( 2 )

    objOut.WriteLine( Request.Form("PageContent") )
    objOut.Close()

  End If

  ' try drawing a pages code
  If page <> "" Then

    Set objFSO = Server.CreateObject( "Scripting.FileSystemObject" )
    Set objFile = objFSO.GetFile( page )
    Set objIn = objFile.OpenAsTextStream()
    content = ""

    ' get page content
    Do While objIn.AtEndOfStream <> True

      content = content + Server.HTMLEncode( objIn.readLine() )

    Loop

    objIn.Close()


%>

<p>
[ <a href="Default.asp?Folder=<%= Server.URLEncode(Request("Folder")) %>">FileManager</a> ]
</p>

<div class="heading">Editing <%= page %></div><br />

<form method="post" action="/Admin/EditPage.asp">

  <input type="hidden" name="Action" value="UpdatePage" />
  <input type="hidden" name="PageName" value="<%= page %>" />

  <b>Page Content:</b><br />
  <textarea cols="90" rows="22" name="PageContent"><%= content %></textarea>

  <br /><br />

  <input type="submit" value="Update Page" />

</form>

<%

  End If

%>

</body>
</html>
