<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->

<%

  var fields = new Array( 'boardName', 'realName', 'gender', 'from', 'dateOfBirth', 'email', 'image', 'website', 'stuff' );

  var objRS = Server.CreateObject( 'ADODB.RecordSet' );
  var objFSO = Server.CreateObject( 'Scripting.FileSystemObject' );
  var objFile = objFSO.GetFile( 'd:/sites/asprad/scripts/profiles.txt' );
  var objIn = objFile.OpenAsTextStream();

  objRS.Open( 'Profiles', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  while ( !objIn.AtEndOfStream ) {

    var username = new String( objIn.ReadLine() );
    var error = false;

    try {
      objRS.Find( 'name = \'' +username.toUpperCase()+ '\'' );
    }
    catch ( e ) {
      Response.Write( 'FindError: ' +e );
    }

    if ( objRS.EOF || objRS.BOF && !error ) {

      objRS.AddNew();
      objRS('username') = username;
      objRS('name') = username.toUpperCase();

      for ( var i in fields ) {
        var value = new String( objIn.ReadLine() ).substr( 0, 250 );
        try {
          objRS(fields[i]) = value;
        }
        catch ( e ) {
          Response.Write( 'Error: ' +e );
        }
      }

      objRS('hits') = 0;
      objRS('lastUpdated') = new Date().getTime();
      objRS('lastAccess') = new Date().getTime();

//      Response.Write( username+ ' Created! <br />' );

      objRS.Update();

    }
    else
      for ( var i in fields ) objIn.ReadLine();

  }

  objRS.Close();

%>

Done.