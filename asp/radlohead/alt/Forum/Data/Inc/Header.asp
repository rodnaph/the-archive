<%

  ' set skin

  If allowSkins And Request("Skin") <> "" Then
    Session("Skin") = Request("Skin")
  End If

  If Session("Skin") = "" Then
    Session("Skin") = "Default"
  End If

%>

<html>
<head>

<title>Forum</title>

<link href="Data/Skins/<%= Session("Skin") %>/CSS/Stylesheet.css" rel="stylesheet" type="text/css" />

<script language="javascript" type="text/javascript" src="Data/JScript/JScriptLib.js"></script>

</head>

<body>

<p align="right">
&lt;
 <a class="TitleLink" href="Default.asp">Forum</a> :
 <a class="TitleLink" href="Register.asp">Register</a> :
 <a class="TitleLink" href="Search.asp">Search</a>
&gt;
</p>
