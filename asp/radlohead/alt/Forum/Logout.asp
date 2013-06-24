
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<%

  strName = Session("Name")

  Session("ForumLogin") = ""
  Session("Name") = ""
  Session("UserID") = ""
  Session("Admin") = False

%>

<p>
 <div class="Heading1">&lt; Logout &gt;</div>
</p>

<p>
<span class="UserName"><%= strName %></span>, you are now logged out.  You will need to log back in before you
use the Forum again.
</p>

<!--#include file="Data/Inc/Footer.asp"-->