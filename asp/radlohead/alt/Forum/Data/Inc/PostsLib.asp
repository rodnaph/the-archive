<%

  ''''''''''''''''''''''''''''''''''''''''
  '
  '  drawReply( objPost )
  '
  ''''''''''''''''''''''''''''''''''''''''

  Sub drawReply( objPost, topDepth )

    Dim postDepth, strPrefix, width

    postDepth = objPost("Depth") - topDepth
    width = postDepth * 15
    strPrefix = "<img src='Data/Images/spacer.gif' height='1' width='" & width & "' alt='' /><img src='Data/Skins/" & Session("Skin") & "/Images/reply.gif' width='8' height='7' alt='' />"

%>
  <tr class="TableMain"
      onmouseover="highlightItem(this,Colors.OVER_ITEM_COLOR)"
      onmouseout="highlightItem(this,Colors.OFF_ITEM_COLOR)"
      onclick="self.location.href='Post.asp?ThreadID=<%= objPost("ThreadID") %>&PostID=<%= objPost("PostID") %>&Depth=<%= objPost("Depth") %>'">
   <td>
    &nbsp;
    <%= strPrefix %>
    &nbsp;
    <a class="TableItem" href="Post.asp?ThreadID=<%= Request("ThreadID") %>&PostID=<%= objPost("PostID") %>&Depth=<%= objPosts("Depth") %>"><%= objPost("Subject") %></a>
   </td>
   <td align="center">
    <nobr>
     &nbsp;
     <a class="UserName" href="User.asp?UserID=<%= objPost("UserID") %>"><%= objPost("Name") %></a>
     &nbsp;
    </nobr>
   </td>
   <td width="110" align="center">
    <span class="TableItem"><%= objPost("DatePosted") %></span>
   </td>
  </tr>
<%

  End Sub

  ''''''''''''''''''''''''''''''''''''''''
  '
  '  drawReplies()
  '
  ''''''''''''''''''''''''''''''''''''''''

  Sub drawReplies( objPosts, topPostDepth )

    Dim strDepth, strFilter

    strDepth = objPosts("Depth") + 1
    strFilter = "ParentID = " & objPosts("PostID") & " AND Depth = " & strDepth

    objPosts.Filter = strFilter

    Do While Not objPosts.EOF

      Dim CurrID

      drawReply objPosts, topPostDepth
      CurrID = objPosts("PostID")

      drawReplies objPosts, topPostDepth

      objPosts.Filter = strFilter

      objPosts.MoveFirst
      objPosts.Find "PostID = " & CurrID

      objPosts.MoveNext

    Loop

    objPosts.Filter = adFilterNone

  End Sub

  ''''''''''''''''''''''''''''''''''''''''
  '
  '  drawPost( objPost )
  '
  ''''''''''''''''''''''''''''''''''''''''

  Sub drawPost( objPost )
%>

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr class="TableBorder"><td>
 <table width="100%" cellpadding="2" cellspacing="1" border="0">
  <tr class="TableHeader">
   <td width="40"> &nbsp; <span class="TableSubTitle">Title:</span></td>
   <td>
   &nbsp;
   <span class="TableItem"><%= objPost("Subject") %></span>
   </td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">User:</span></td>
   <td>
    &nbsp;
    <a class="UserName" href="User.asp?UserID=<%= objPost("UserID") %>"><%= objPost("Name") %></a>
   </td>
  </tr>
  <tr class="TableHeader">
   <td> &nbsp; <span class="TableSubTitle">Date:</span></td>
   <td>
     &nbsp;
     <span class="TableItem"><%= objPost("DatePosted") %></span>
   </td>
  </tr>
  <tr class="TableMain">
   <td colspan="2">
    <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>
      <span class="TableItem"><%= objPost("Message") %></span>
    </td></tr></table>
   </td>
  </tr>
 </table>
</td></tr></table>

<%
  End Sub

%>