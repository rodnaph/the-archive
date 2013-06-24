
<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Login.asp"-->

<p>
 <div class="Heading1">&lt; New Thread &gt;</div>
</p>

<%

  If Request.Form("Action") = "DoNewThread" Then

    Dim objThreads, strSubject, newThreadID, strMessage

    strMessage = Server.HTMLEncode( Request.Form("Message") )
    strSubject = Request.Form("Subject")
    newThreadID = 1

    If strSubject <> "" And strMessage = "" Then

      Set objThreads = Server.CreateObject( "ADODB.RecordSet" )

      objThreads.Open "Threads", strConnect, adOpenDynamic, adLockPessimistic

      '  set thread id

      If Not objThreads.EOF Then

        objThreads.MoveLast
        newThreadID = objThreads("ThreadID") + 1

      End If

      '  create new thread

      objThreads.AddNew
      objThreads("ThreadID") = newThreadID
      objThreads("UserID") = Session("UserID")
      objThreads("Subject") = strSubject
      objThreads("DateCreated") = Now
      objThreads("LastPost") = Now
      objThreads("Message") = strMessage
      objThreads.Update
      objThreads.Close

      '  give output
%>

<p>
 Success!  <span class="UserName"><%= Session("Name") %></span> you have created a new thread with the following title...
</p>

<blockquote><%= strSubject %></blockquote>

<p>
 You can start posting in this thread right now by clicking
 <a href="Thread.asp?ThreadID=<%= newThreadID %>">here</a>
</p>

<%

    Else
%>

<p>
 Sorry, but you did not enter valid information for the thread you were trying to create,
 please try again.
</p>

<%
    End If

  Else

%>

<p>
 To start a brand new thread of discussion all you need to do is to fill in the details
 needed in the form below, then just hit the create button.  The title of the thread
 should indicate the topic or topics that are to be discussed in that thread, but this
 is not a rule, just a guideline.
</p>

<form method="post" action="NewThread.asp">

 <input type="hidden" name="Action" value="DoNewThread" />

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
    <input type="text" class="InputText" name="Subject" size="95" maxlength="60" value="" />
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
    <textarea class="InputText" name="Message" cols="134" rows="10"></textarea>
   </td>
  </tr>
  <tr class="TableHeader"><td align="right" colspan="2">
    <input class="InputSubmit" type="submit" value="Start Thread" />
  </td></tr>
 </table>
</td></tr></table>

</form>

<%

  End If

%>

<!--#include file="Data/Inc/Footer.asp"-->