<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->

<%

  var objRS = Server.CreateObject( 'ADODB.RecordSet' );
  var objFSO = Server.CreateObject( 'Scripting.FileSystemObject' );
  var objFile = objFSO.GetFile( 'd:/sites/asprad/scripts/stuff.txt' );
  var objIn = objFile.OpenAsTextStream();

  objRS.Open( 'Profiles', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  while ( !objIn.AtEndOfStream ) {

    var tag = objIn.ReadLine();
    var username = new String( objIn.ReadLine() );
    var stuff = new String( objIn.ReadLine() );

    if ( username.match( /^z/i ) ) {

      try {

        objRS.Find( 'name = \'' +username.toUpperCase()+ '\'' );

        if ( !objRS.EOF && !objRS.BOF ) {

          Response.Write( username+ '<br />' );
          objRS('stuff') = stuff;
          objRS.Update();

        }

        objRS.MoveFirst();

      }
      catch( e ) {
        Response.Write( 'Error:' +username+ '<br />' );
      }

    }

  }

  objRS.Close();

%>

Done.