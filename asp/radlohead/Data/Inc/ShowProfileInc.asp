<%

  function DF( text, name ) {
    this.text = text;
    this.name = name;
  }

  var user = new String( Request('user') );
  var displayFields = new Array( new DF( 'Board Names', 'boardName' ),
                                 new DF( 'Real Name', 'realName' ),
                                 new DF( 'Gender', 'gender' ),
                                 new DF( 'From', 'from' ),
                                 new DF( 'Date Of Birth', 'dateOfBirth' ) );

  var objConn = Server.CreateObject( 'ADODB.Connection' );
  var objProfiles = Server.CreateObject( 'ADODB.RecordSet' );

  objConn.Open( strConnect );
  objProfiles.Open( 'SELECT * FROM Profiles WHERE name LIKE \'' +user+ '\'', objConn );

  // check a user is to be drawn
  if ( user == 'undefined' || user.length == 0 ) {
    drawNode( 41 );
    %><!--#include virtual="/Data/Inc/Footer.asp"--><%
    Response.End();
  }

  if ( objProfiles.EOF ) drawNode( 28 );
  else {

    // update hits
    var objComm = Server.CreateObject( 'ADODB.Command' );
    objComm.ActiveConnection = objConn;
    objComm.CommandText = 'UPDATE Profiles SET hits = (hits + 1) WHERE name LIKE \'' +user+ '\'';
    objComm.CommandType = adCmdText;
    objComm.Execute();

    image = ( ''+objProfiles('image') != '' ) ? '<img bordercolor="#000000" border="1" src="/Images/Show.pl?url=' +Server.URLEncode(objProfiles('image'))+ '" alt="' +objProfiles('image')+ '" /><br /><br />' : '';
    website = ( ''+objProfiles('website') != '' ) ? '<b>Website:</b> <a href="' +objProfiles('website')+ '" target="_blank">' +objProfiles('website')+ '</a><br />' : '';
    email = ( ''+objProfiles('email') != '' ) ? '<b>Email:</b> <a href="mailto:' +objProfiles('email')+ '">' +objProfiles('email')+ '</a><br />' : '';

    var encName = Server.URLEncode( objProfiles('username') );

%>

<table width="100%">
 <tr>
  <td class="heading"><%= objProfiles('username') %></td>
  <td align="right">
   [
    <a href="/Profiles/CreateProfile.asp?username=<%= encName %>">Edit</a> |
    <a href="/Profiles/DeleteUser.asp">Delete</a> |
    <a href="/Nodes/UserNodes.asp?user=<%= encName %>">Nodes</a>
   ]
  </td>
 </tr>
</table>

<br />
<%= image %>
<%= website %>
<%= email %>

<%

  for ( var i in displayFields ) {

    var df = displayFields[i];
    var value = objProfiles( df.name );

    if ( value != '' ) {
%>
<br /><b><%= df.text %></b> <br />
<%= value %>
<%
    }

  }

%>

<br /><br />
<b>Stuff</b><br />
<%= objProfiles('stuff') %>

<p align="right">
 Last Updated: <i><%= new Date( objProfiles('lastUpdated')/1 ) %></i><br />
 Hits Since April 30: <i><%= objProfiles('hits') %></i>
</p>

<%

  }

%>