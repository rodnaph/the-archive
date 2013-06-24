
<form method="get" name="skinForm" action="<%= Request.ServerVariables("URL") %>">

<% For Each item In Request.QueryString
    If item <> "Skin" Then %>
      <input type="hidden" name="<%= item %>" value="<%= Request.QueryString(item) %>" />
<%  End If
  Next %>

<span class="TitleLink">Skin:</span>

<select name="Skin" onchange="changeSkin()" class="InputText">
  <option value="" selected="selected"></option>

<% For Each item In objSkins %>
  <option value="<%= item %>"><%= item %></option>
<% Next %>

</select>

</form>

