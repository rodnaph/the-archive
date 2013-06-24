<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/BirthdaysHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var days = Request('days') / 1;
  var month = new String( Request('month') );

  drawNode( 69 );

  // check data
  if ( (isNaN(days)) || (days>31) || (month.length==0) ) {
    %><!--#include virtual="/Data/Inc/Footer.asp"--><%
  }

  var objBirthdays = Server.CreateObject( 'ADODB.RecordSet' );
  objBirthdays.Open( 'SELECT * FROM Birthdays WHERE month LIKE \'' +month+ '\'', strConnect, adOpenDynamic );

%>

<div class="heading"><%= month %></div>

<br />

<table width="100%" cellpadding="2" cellspacing="0" border="0">

<%

  var day = 1;

  if ( days > 31 ) days = 31;

  for ( var i=1; i<9; i++ ) {
    %><tr><%
    for ( var j=1; j<6; j++ ) {
      %><td width="20%"><%
      if ( day < days+1 ) {
%>

<!-- start day <%= day %> -->

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#000000"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0"><tr bgcolor="#aaaaaa"><td>

  <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr bgcolor="#99aaaa">
   <td align="right">

    <b><%= day %></b>
    &nbsp;

   </td>
  </tr></table>
  <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
   <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  </tr></table>
  <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>

<%

    objBirthdays.Filter = 'day = ' +day+ '\'';

    while ( !objBirthdays.EOF ) {
%>

<a href="/Profiles/ShowProfile.asp?user=<%= Server.URLEncode(objBirthdays('username')) %>"><%= objBirthdays('username') %></a> <br />

<%
      objBirthdays.MoveNext();
    }

    objBirthdays.Filter = adFilterNone;

%>

  </td></tr></table>

 </td></tr></table>
</td></tr></table>

<!-- end day <%= day %> -->

<%
      }
      day++;
      %></td><%
    }
    %></tr><%
  }

%>

</table>

<!--#include virtual="/Data/Inc/Footer.asp"-->