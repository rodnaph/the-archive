<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var id = Request('id');
  var objComm = Server.CreateObject( 'ADODB.Command' );

  objComm.ActiveConnection = strConnect;
  objComm.CommandText = 'qryContactByID';
  objComm.CommandType = adCmdStoredProc;
  objComm.Parameters.Append( objComm.CreateParameter( 'ID', adSmallInt, adParamInput, 20, id ) );

  var objContact = objComm.Execute();

%>

<table width="100%">
 <tr>
  <td class="heading">Viewing Contact <%= id %></td>
  <td align="right">
   [
    <a href="/Admin/DeleteContact.asp?id=<%= id %>">Delete</a> |
    <a href="/Admin/SendEmail.asp?To=<%= Server.URLEncode( objContact('Email') ) %>">Reply</a>
   ]
  </td>
 </tr>
</table>

<br />

<b>From:</b> <%= objContact('From') %><br />
<b>SentOn:</b> <%= new Date( objContact('SentOn')/1 ) %><br />
<b>Subject:</b> <%= objContact('Subject') %><br />
<b>Email:</b> <%= objContact('Email') %>

<blockquote>
  <%= objContact('Message') %>
</blockquote>

<%

  objContact.Close();

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->