<%

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  validUser()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function validUser( username, password, objUsers ) {

  username = new String( username );

  if ( objUsers == null ) {
    objUsers = Server.CreateObject( 'ADODB.RecordSet' );
    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );
  }

  objUsers.Find( "name = '" +username.toUpperCase()+ "'" );

  if ( !objUsers.EOF && !objUsers.BOF )
    if ( ''+objUsers('password') == password )
      return true;

  return false;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  userExists()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function userExists( username, objUsers ) {

  username = new String( username );

  if ( objUsers == null ) {
    objUsers = Server.CreateObject( 'ADODB.RecordSet' );
    objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );
  }

  objUsers.Find( "name = '" +username.toUpperCase()+ "'" );

  if ( !objUsers.EOF && !objUsers.BOF )
    return true;
  else
    return false;

}

%>