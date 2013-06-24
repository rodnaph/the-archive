
<%

  Dim depth

  depth = Request("Depth")

  If depth = "" Or Depth < 0 Then

    depth = 0

  End If

%>

<br />

<a name="PostForm"></a>

<form method="post" onsubmit="return checkPost(this);" action="MakePost.asp">

 <input type="hidden" name="Action" value="DoMakePost" />
 <input type="hidden" name="Depth" value="<%= depth %>" />
 <input type="hidden" name="ThreadID" value="<%= Request("ThreadID") %>" />
 <input type="hidden" name="ParentID" value="<%= strParentID %>" />

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="0" cellspacing="1" border="0">

  <tr class="TableHeader">
   <td width="70">
    <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
     &nbsp;
     <span class="TableSubTitle">Subject:</span>
    </td></tr></table>
   </td>
   <td>
    &nbsp;
    <input class="InputText" type="text" name="Subject" size="95" maxlength="60" value="" tabindex="1" />
   </td>
  </tr>
  <tr class="TableHeader">
   <td valign="top">
    <table width="100%" cellpadding="2" cellspacing="0" border="0"><tr><td>
     &nbsp;
     <span class="TableSubTitle">Message:</span>
    </td></tr></table>
   </td>
   <td>
    &nbsp;
    <textarea class="InputText" name="Message" cols="134" rows="10" tabindex="2"></textarea>
   </td>
  </tr>
  <tr class="TableHeader"><td align="right" colspan="2">
    <input type="submit" value="Post Message" tabindex="3" class="InputSubmit" />
  </td></tr>
 </table>
</td></tr></table>

</form>
