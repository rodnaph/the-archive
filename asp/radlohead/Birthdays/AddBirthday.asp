<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/BirthdaysHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

  objNodes.Open( 'Nodes', strConnect, adOpenDynamic );

  if ( Request.Form('action') == 'AddBirthday' ) {

    var username = new String( Request.Form('username') );
    var month = Request.Form('month');
    var day = Request.Form('day') / 1;

    if ( validUser( username, Request.Form('password') ) ) {

      var objBirthdays = Server.CreateObject( 'ADODB.RecordSet' );

      objBirthdays.Open( 'Birthdays', strConnect, adOpenDynamic, adLockOptimistic );
      objBirthdays.Find( "name = '" +username.toUpperCase()+ "'" );

      // create new record if needed
      if ( objBirthdays.EOF ) {
        objBirthdays.AddNew();
        objBirthdays('name') = username.toUpperCase();
      }

      // set birthday data
      objBirthdays('username') = username;
      objBirthdays('month') = month;
      objBirthdays('day') = day;

%>

<div class="heading">Birthday Added</div>

<p>
Success, <%= username %> your birthday has been added to the system!
</p>

<%

      // update and close
      objBirthdays.Update();
      objBirthdays.Close();

    }
    else drawNode( 12 );

  }
  else drawNode( 34, objNodes );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->