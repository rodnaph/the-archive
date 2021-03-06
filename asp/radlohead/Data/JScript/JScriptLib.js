//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//
//  JScriptLib.js
//
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

var profileWin = null;

//////////////////////////////////////////////////////////////////////////////////////////
//
//  drawProfiles()
//
//////////////////////////////////////////////////////////////////////////////////////////

function drawProfiles( from, to, drawRest ) {

  from = new String(from);
  to = new String(to);

  document.writeln( '<tr>' );

  for ( var i=from.charCodeAt(0); i<(to.charCodeAt(0)+1); i++ ) {

    var c = String.fromCharCode(i);
    document.writeln( '<td align="center">' +
                      '<a href="/Profiles/ShowUsers.asp?users=' +c+ '"><b>' +c+ '</b></a></td>' );

  }

  if ( drawRest ) {

    document.writeln( '<td colspan="2" align="center">' +
                      '<a href="/Profiles/ShowUsers.asp?users=rest"><b>rest</b></a></td>' );

  }

  document.writeln( '</tr>' );

}

//////////////////////////////////////////////////////////////////////////////////////////
//
//  createUsersLinks()
//
//////////////////////////////////////////////////////////////////////////////////////////

function createUsersLinks() {

  document.writeln( '<table width="100%">' );

  drawProfiles( 'a', 'g' );
  drawProfiles( 'h', 'n' );
  drawProfiles( 'o', 'u' );
  drawProfiles( 'v', 'z', true );

  document.writeln( '</table>' );

}

//////////////////////////////////////////////////////////////////////////////////////////
//
//  highlightItem( objItem, color )
//
//////////////////////////////////////////////////////////////////////////////////////////

function highlightItem( objItem, color ) {

  objItem.style.backgroundColor = color;

}

//////////////////////////////////////////////////////////////////////////////////////////
//
//  showProfileWin( user )
//
//////////////////////////////////////////////////////////////////////////////////////////

function showProfileWin( user ) {

  // close window if already exists
  if ( profileWin != null )
    profileWin.close();

  // open the window
  profileWin = window.open( '/Profiles/ProfileWin.asp?user=' +user, 'ProfileWin', 'toolbars=no,scrollbars=yes,width=600,height=400,left=100,top=100' );

}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
