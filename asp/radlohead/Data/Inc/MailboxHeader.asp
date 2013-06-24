<%

  var loginName, loginPass;

  if ( Session('loggedIn') != true ) {
    Response.Redirect( '/Login.asp' );
    Response.End();
  }
  else {
    loginName = new String( Session('loginName') );
    loginPass = new String( Session('loginPass') );
  }

  leftNode = 52;

%>