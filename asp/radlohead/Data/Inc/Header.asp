<%

  //
  //  set stylesheet
  //

  var stylesheet = 'default';
  var styleText = 'BigText';
  var styleLink = 'big';

  if ( ( Request('style') != 'norm' ) &&
       ( (Request('style') == 'big') || (Session('style') == 'big') ) ) {

    stylesheet = 'big';
    styleText = 'Normal';
    styleLink = 'norm';

  }

  Session('style') = stylesheet;

  //
  //  set connection object
  //

  var objConn = Server.CreateObject( 'ADODB.Connection' );
  objConn.Open( strConnect );

  //
  //  update page hits table
  //

  var objHits = Server.CreateObject( 'ADODB.RecordSet' );
  var pageURL = new String( Request.ServerVariables('URL') );

  objHits.Open( 'PageHits', objConn, adOpenDynamic, adLockPessimistic );
  objHits.Find( 'url LIKE \'' +pageURL+ '\'' );

  if ( objHits.EOF || objHits.BOF ) {
    objHits.AddNew();
    objHits('url') = pageURL;
    objHits('hits') = 1;
  }

  objHits('hits') = (objHits('hits')/1) + 1;
  objHits.Update();
  objHits.Close();

%>
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>radlohead.com</title>

<link href="/Data/CSS/<%= stylesheet %>.css" rel="stylesheet" type="text/css" />

<script language="javascript"
        type="text/javascript"
        src="/Data/JScript/JScriptLib.js">
</script>

</head>

<body leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" marginheight="0" marginwidth="0" background="/Data/Images/back.gif">

<!-- start nav bar -->

<table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td bgcolor="#eeeeee">

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr><td>
    
    &nbsp;

     <b><a href="/Profiles">Profiles</a></b> |
     <b><a href="/Birthdays">Birthdays</a></b> |
     <b><a href="/Images">Images</a></b> |
     <b><a href="/Nodes">Nodes</a></b> |
     <b><a href="/Msgboard">Msgboard</a></b> |
     <b><a href="/Webring">Webring</a></b> |
     <b><a href="/Mailbox">Mailbox</a></b>
    
    &nbsp; &nbsp;
    
   </td></tr></table>

  </td>
  <td><img src="/Data/Images/top_divide.gif" height="20" width="20" alt="" /></td>
  <td>

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr><td align="right">

    <b>
     <a href="http://radlohead.com/">radlohead.com</a>
    </b>
    &nbsp;

   </td></tr></table>

  </td>
 </tr>
 <tr>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td></td>
  <td></td>
 </tr>
</table>

<!-- end nav bar -->

<table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td valign="top">

  <!-- start left box -->

  <table width="150" cellpadding="0" cellspacing="0" border="0">
   <tr>
    <td bgcolor="#cccccc">
     <table width="100%" cellpadding="7" cellspacing="0" border="0"><tr><td>

      <div class="smallheading" align="right">Profiles</div>

      Use the links below to view the profiles by letter.

      <br /><br />

      <script language="javascript" type="text/javascript">

      createUsersLinks();

      </script>

     </td></tr></table>
    </td>
    <td width="1" bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
   </tr>
   <tr>
    <td colspan="2" bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
   </tr>
  </table>

  <!-- end left box -->

  <br />

  <table cellpadding="6" cellspacing="0" border="0"><tr><td>

<%

  drawNodes( leftNode, linksNode, 77 );

%>

  </td></tr></table>

  </td>
  <td width="100%" valign="top">

  <table width="100%" cellpadding="10" cellspacing="0" border="0"><tr><td>
