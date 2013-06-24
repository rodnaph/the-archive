<%@ language="JScript" @%>

<!--#include file="Data/Inc/Config.asp"-->
<!--#include file="Data/Inc/BoardLib.asp"-->
<!--#include file="Data/Inc/Header.asp"-->
<!--#include file="Data/Inc/Links.asp"-->

<p>
 <b>Board Search</b>
</p>

<p>
 To search the database just select the area you wish to search using the drop down
 menu below, then enter the keyword you want to search for (searches are NOT case
 sensitive).
</p>

<form method="post" action="Search.asp">

  <input type="hidden" name="Action" value="Search" />

  <b>Area</b> &nbsp;
  <select name="Field">
    <option value="Name">Name</option>
    <option value="Subject">Subject</option>
    <option value="Message">Message</option>
    <option value="Date">Date Posted</option>
  </select>

  <br /><br />

  <b>Keyword</b><br />
  <input type="text" name="Keyword" size="58" maxlength="60" value="<%= Request.Form('Keyword') %>" />

  <br /><br />

  <input type="submit" value="Perform Search" />

</form>

<%

  if ( (Request.Form('Action') == 'Search') &&
       (Request.Form('Keyword') != '') ) {

%>

<hr>

<b>Search Results</b>
<br /><br />

<ul>

<%

    var objPosts = Server.CreateObject( 'ADODB.RecordSet' );

    objPosts.Open( 'Posts', strConnect );
    objPosts.Filter = Request.Form('Field')+ ' LIKE \'%' +Request.Form('Keyword')+ '%\'';

    while ( !objPosts.EOF ) {

      drawReply( objPosts );
      objPosts.MoveNext();

    }

  }

%>

</ul>

<!--#include file="Data/Inc/Footer.asp"-->