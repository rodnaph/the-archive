<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/Nodes.asp"-->
<!--#include virtual="/Data/Inc/Users.asp"-->
<!--#include virtual="/Data/Inc/WebringHeader.asp"-->
<!--#include virtual="/Data/Inc/Header.asp"-->

<%

  var objNodes = Server.CreateObject( 'ADODB.RecordSet' );

  objNodes.Open( 'Nodes', strConnect, adOpenDynamic );

  if ( Request.Form('action') == 'JoinWebring' ) {

    var user = new String( Request.Form('username') );
    var url = new String( Request.Form('url') );

    if ( validUser( user, Request.Form('password') ) ) {

      var objWebring = Server.CreateObject( 'ADODB.RecordSet' );
      var doJoin = true;

      objWebring.Open( 'Webring', strConnect, adOpenDynamic, adLockPessimistic, adCmdTable );

      // check user doesn't already have a site
      objWebring.Filter = 'owner = \'' +user+ '\' OR url = \'' +url+ '\'';
      if ( !objWebring.EOF ) doJoin = false;
      else objWebring.Filter = adFilterNone;

      if ( doJoin ) {

        var id = 1;

        if ( !objWebring.EOF && !objWebring.BOF )
          objWebring.MoveFirst();

        if ( !objWebring.EOF ) {
          objWebring.MoveLast();
          id = ( objWebring('id') / 1 ) + 1;
        }

        // add record
        objWebring.AddNew();
        objWebring('id') = id;
        objWebring('owner') = user;
        objWebring('url') = Request.Form('url');
        objWebring('desc') = Request.Form('desc');
        objWebring('dateAdded') = new Date().getTime();

%>

<div class="heading">Joined Webring</div>

<p>
Success, <%= user %> your website has been added to the webring.  The final step you
have to now take is to take the code provided below, and display it somewhere on your
website.
</p>

<p><code><pre>
[
 &lt;a href="http://www.radlohead.com/Webring/Back.asp?id=<%= id %>"&gt;Back&lt;/a&gt; |
 &lt;a href="http://www.radlohead.com/Webring/JoinWebring.asp"&gt;Join&lt;/a&gt; |
 &lt;a href="http://www.radlohead.com/Webring/RandomSite.asp"&gt;Random&lt;/a&gt; |
 &lt;a href="http://www.radlohead.com/Webring/Members.asp"&gt;List&lt;/a&gt; |
 &lt;a href="http://www.radlohead.com/Webring/Next.asp?id=<%= id %>"&gt;Back&lt;/a&gt;
]
</pre></code></p>

<%

        // update and close
        objWebring.Update();
        objWebring.Close();

      }
      else drawNode( 48, objNodes );

    }
    else drawNode( 12, objNodes );

  }
  else drawNode( 47, objNodes );

%>

<!--#include virtual="/Data/Inc/Footer.asp"-->