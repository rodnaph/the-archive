
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<p>
 <div class="Heading1">&lt; Users &gt;</div>
</p>

<%

  Dim UserID, objComm, objPriFlds(1)

  UserID = Request("UserID")
  objPriFlds(0) = "Password"
  objPriFlds(1) = "Email"

  Set objComm = Server.CreateObject( "ADODB.Command" )
  objComm.ActiveConnection = strConnect
  objComm.CommandType = adCmdStoredProc
  objComm.CommandText = "qryUserByID"
  objComm.Parameters.Append( objComm.CreateParameter( "ID", adSmallInt, adParamInput, 50, UserID ) )

  Set objUser = objComm.Execute

  If objUser.EOF Then %>

<p>
 Sorry, but there is no user with that ID in the database.
</p>

<% Else

%>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td width="80"> &nbsp; <span class="TableSubTitle">User:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objUser("Name") %></span></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Posts:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objUser("NoOfPosts") %></span></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Last Post:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objUser("LastPost") %></span></td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Date Joined:</span></td>
   <td> &nbsp; <span class="TableItem"><%= objUser("DateJoined") %></span></td>
  </tr>

<% If UCase(Session("Name")) = UCase(objUser("Name")) Then %>

<form method="post" action="UpdateUser.asp">

  <input type="hidden" name="Action" value="UpdateUser" />

  <% For Each item In objPriFlds %>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle"><%= item %>:</span></td>
   <td> &nbsp; <input type="text" name="<%= item %>" size="60" maxlength="40" value="<%= objUser(item) %>" class="InputText" /></td>
  </tr>
  <% Next %>

  <tr class="TableHeader">
   <td colspan="2" align="right">
    <input type="submit" class="InputSubmit" value="Update" />
   </td>
  </tr>

</form>

<% End If %>

 </table>
</td></tr></table>

<% End If %>

<br />

<!--#include file="Data/Inc/Footer.asp"-->