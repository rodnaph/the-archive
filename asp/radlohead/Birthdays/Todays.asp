<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/BirthdaysHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var months = new Array( 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December' );

  var now = new Date();
  var month = months[ now.getMonth() ];
  var day = now.getDate();

%>

<div class="heading"><%= month %>&nbsp;<%= day %></div><br />

<table width="100%" cellpadding="3" cellspacing="0" border="1" bordercolor="#000000" bgcolor="#aaaaaa">
 <tr>
  <td bgcolor="#cccccc">
   &nbsp;
   <b>User</b>
  </td>
 </tr>

<%

  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryBirthdaysByDate';
  objComm.CommandType = adCmdStoredProc;

  objComm.Parameters.Append( objComm.CreateParameter( 'month', adVarChar, adParamInput, 20, month ) );
  objComm.Parameters.Append( objComm.CreateParameter( 'day', adSmallInt, adParamInput, 50, day ) );

  var objBirthdays = objComm.Execute();

  while ( !objBirthdays.EOF ) {
    var user = objBirthdays('username');
%>
 <tr>
  <td>
   &nbsp;
   <a href="/Profiles/ShowProfile.asp?user=<%= Server.URLEncode( user ) %>"><%= user %></a><br />
  </td>
 </tr>
<%
    objBirthdays.MoveNext();
  }

  objBirthdays.Close();

%>

</table>

<!--#include virtual="/Data/Inc/Footer.asp"-->