<%@ language="jscript" @%>

<!--#include virtual="/data/inc/Config.asp"-->

<%

  var objProfiles = Server.CreateObject( 'ADODB.RecordSet' );
  var objRS = Server.CreateObject( 'ADODB.RecordSet' );
  var objFSO = Server.CreateObject( 'Scripting.FileSystemObject' );
  var objFile = objFSO.GetFile( 'd:/sites/asprad/scripts/out.txt' );
  var objIn = objFile.OpenAsTextStream();

  objProfiles.Open( 'Profiles', strConnect, adOpenDynamic );
  objRS.Open( 'Users', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  while ( !objIn.AtEndOfStream ) {

    var name = new String( objIn.ReadLine() );
    var password = objIn.ReadLine();
    var profile = new String( objIn.readLine() );

    objRS.AddNew();
    objRS('name') = name.toUpperCase();
    objRS('username') = name;
    objRS('password') = password;
    objRS('hasProfile') = ( profile == '1' ) ? true : false;

    Response.Write( name+ ' Added!<br />' );

  }

  objRS.Update();
  objRS.Close();
  objProfiles.Close();

%>