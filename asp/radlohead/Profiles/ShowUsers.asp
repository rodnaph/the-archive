<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/ProfilesHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var users = new String( Request('users') );
  var regExp = ( users == 'rest' ) ? new RegExp( '^[0-9 !\-._]' )
                                   : new RegExp( '^' +users.toUpperCase().charAt(0) );

%>

<div class="heading">Users <%= users %></div><br />

<%

  var objUsers = Server.CreateObject( 'ADODB.RecordSet' );
  objUsers.Open( 'Users', strConnect, adOpenForwardOnly, adLockReadOnly );

  while ( !objUsers.EOF ) {

    var name = new String( objUsers('name') );
    var type = ( objUsers('hasProfile') == true ) ? 'b' : 'i';

    if ( name.match( regExp ) ) {

%>
<b><<%= type %>><a href="/Profiles/ShowProfile.asp?user=<%= Server.URLEncode(objUsers('username')) %>"><%= objUsers('username') %></a></<%= type %>> <br />
<%
    }

    objUsers.MoveNext();

  }

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->