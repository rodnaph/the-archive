<%

  Dim strConnect, allowSkins, objSkins(1)

  strConnect = "Driver={Microsoft Access Driver (*.mdb)}; DBQ=" & Server.MapPath(".") & "/Data/DB/Forum.mdb"
  allowSkins = True

  ' stylesheet names
  objSkins(0) = "Default"
  objSkins(1) = "Tech"

%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->