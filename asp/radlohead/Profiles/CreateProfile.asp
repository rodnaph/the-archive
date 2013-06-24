<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  // set some vars
  var username = new String( Request('username') );
  var htmlHelp = false;

  if ( (username.length == 0) || (username=='undefined') ) {
    drawNode( 30 );
%><!--#include virtual="/Data/Inc/Footer.asp"--><%
    Response.End();
  }

  // create variables
  for ( var i in fields )
    eval( 'var ' +fields[i]+ ' = \'\';' );

  if ( Request.Form('action') == 'CreateProfile' ) {

    // update/create a profile
    if ( validUser( Request.Form('username'), Request.Form('password') ) ) {

      //
      // update user info...
      //

      var objUsers = Server.CreateObject( 'ADODB.RecordSet' );

      objUsers.Open( 'Users', strConnect, adOpenDynamic, adLockPessimistic );
      objUsers.Find( 'name = \'' +new String( Request.Form('username') ).toUpperCase()+ '\'' );
      objUsers('hasProfile') = true;
      objUsers.Update();
      objUsers.Close();

      //
      //  update profile...
      //

      var objProfiles = Server.CreateObject( 'ADODB.RecordSet' );

      // open DB and find record
      objProfiles.Open( 'Profiles', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );
      objProfiles.Find( "name = '" +username.toUpperCase()+ "'" );

      // create new record if needed
      if ( objProfiles.EOF || objProfiles.BOF ) {
        objProfiles.AddNew();
        objProfiles('name') = username.toUpperCase();
        objProfiles('username') = username;
        objProfiles('hits') = 0;
      }

      var help = ( Request.Form( 'htmlHelp' ) == 'yes' ) ? true : false;

      // then set fields
      for ( var i in fields ) {

        var field = fields[i];
        var value = new String( Request.Form( field ) );

        // try html help
        if ( help )
          for ( var i in textareas ) {
            if ( textareas[i] == field ) value = value.replace( /\n/g, '<br />' );
          }

        // set value
        objProfiles(field) = value;

      }

      // set other variables
      objProfiles( 'htmlHelp' ) = help;
      objProfiles( 'lastUpdated' ) = new Date().getTime();

      // update and inform user
      objProfiles.Update();

      var escName = Server.URLEncode( username );

%>

<div class="heading">Profile Updated</div>

<p>
Success, <b><%= username %></b> you have updated your profile, you can
view your profile by using the url below.
</p>

<p>
<a href="/Profiles/ShowProfile.asp?user=<%= escName %>">http://www.radlohead.com/Profiles/ShowProfile.asp?user=<%= escName %></a>
</p>

<%
      // cleanup
      objProfiles.Close();

    }
    else drawNode( 12 );

  }

  //
  //  load and draw the editing form
  //

  else {

    var drawForm = true;
    var doing = 'Creating';

    // load profile
    if ( (username.length > 0) && (username != 'null') ) {

      var objProfiles = Server.CreateObject( 'ADODB.RecordSet' );

      objProfiles.Open( 'Profiles', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );
      objProfiles.Find( "name = '" +username.toUpperCase()+ "'" );

      if ( !objProfiles.BOF && !objProfiles.EOF ) {

        doing = 'Editing';

        for ( var i in fields )
          eval( fields[i]+ ' = objProfiles(\'' +fields[i]+ '\');' );

        // set help
        htmlHelp = objProfiles('htmlHelp');

      }
      else {
        doing = 'Creating';
      }

    }

    // check username
    if ( username == 'undefined' ) username = '';

    // draw form
    if ( drawForm ) {

      drawNode( 31 );
%>

<div class="heading"><%= doing %> A Profile</div>

<form method="post" action="/Profiles/CreateProfile.asp">

  <input type="hidden" name="action" value="CreateProfile" />
  <input type="hidden" name="doing" value="<%= doing %>" />

  <!-- user info -->

  <b>Username:</b> <br />
  <input type="text" name="username" size="50" maxlength="50" value="<%= username %>" />

  <br />

  <b>Password:</b> <br />
  <input type="password" name="password" size="50" maxlength="50" />

  <br /><br />

  <!-- profile info -->

<%

  // draw text fields
  for ( var i in textfields ) {

    var field = textfields[i];
    eval( 'var value = ' +field+ ';' );
%>

  <b><%= field %></b> <br />
  <input type="text" name="<%= field %>" size="40" maxlength="50" value="<%= value %>" />

  <br />

<%
  }

  // draw textareas
  for ( var i in textareas ) {

    var field = textareas[i];
    eval( 'var value = new String(' +field+ ');' );

    if ( htmlHelp )
      value = value.replace( /<br \/>/g, "\n" );

%>

  <b><%= field %></b> <br />
  <textarea name="<%= field %>" cols="60" rows="10"><%= Server.HTMLEncode(value) %></textarea>

  <br />

<%
  }

%>

  <br /><br />

  <b>HTML Help?</b> &nbsp; <input type="checkbox" name="htmlHelp" value="yes" />

  <br /><br />

  <input type="submit" value="Update Profile" />

</form>

<%
    }
    else drawNode( 12 );

  }
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->