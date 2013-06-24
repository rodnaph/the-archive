<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/AdminLogin.asp"-->
<!--#include virtual="/Data/Inc/AdminHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  if ( Request.Form('Action') == 'SendEmail' ) {

    var objMail = Server.CreateObject( 'CDONTS.NewMail' )

    objMail.To = Request.Form('To');
    objMail.From = 'admin@radlohead.com';
    objMail.Suject = Request.Form('Subject');
    objMail.Body = Request.Form('Message');
    objMail.Send();

    drawNode( 55 );

  }
  else {
%>

<div class="heading">Sending An Email</div><br />

<form method="post" action="/Admin/SendEmail.asp">

  <input type="hidden" name="Action" value="SendEmail" />

  <b>To:</b><br />
  <input type="text" name="To" size="50" maxlength="100" value="<%= Request('To') %>" />

  <br /><br />

  <b>Subject:</b><br />
  <input type="text" name="Subject" size="50" maxlength="50" />

  <br /><br />

  <b>Message:</b><br />
  <textarea name="Message" cols="60" rows="15"></textarea>

  <br /><br />

  <input type="submit" value="Send Email" />

</form>

<%
  }
%>

<!--#include virtual="/Data/Inc/Footer.asp"-->