<%

  if ( Session('loggedIn') != true ) {

    if ( Request.Cookies('loginName').HasKeys() ) {

      // load session with cookie data
      Session('loggedIn') = true;
      Session('loginName') = Request.Cookies('loginName');
      Session('loginPass') = Request.Cookies('loginPass');

    }

    if ( Request.Form('action') == 'Login' ) {

      var user = new String( Request.Form('username') );

      if ( validUser( user, Request.Form('password') ) ) {

        // set session data
        Session('loggedIn') = true;
        Session('loginName') = user;
        Session('loginPass') = ''+Request.Form('password');

        // set cookie data
        Response.Cookies('loginName') = user;
        Response.Cookies('loginName').Expires = 'July 4, 2030';
        Response.Cookies('loginPass') = Request.Form('password')+'';
        Response.Cookies('loginPass').Expires = 'July 4, 2030';

      } else {

        // invalid login attempt
        %><!--#include virtual="/Data/Inc/Header.asp"--><%
        drawNode( 12 );
        %><!--#include virtual="/Data/Inc/Footer.asp"--><%

      }

    }
    else {

      // user not logged in, draw form
      %><!--#include virtual="/Data/Inc/Header.asp"--><%
      drawNode( 53 );
      %><!--#include virtual="/Data/Inc/Footer.asp"--><%

    }

  }

%>