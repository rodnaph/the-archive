<%@ language="jscript" @%>

<!--#include file="data/inc/Config.asp"-->

<%


  var objRS = Server.CreateObject( 'ADODB.RecordSet' );
  var objFSO = Server.CreateObject( 'Scripting.FileSystemObject' );
  var objFile = objFSO.GetFile( 'd:/sites/asprad/mail.txt' );
  var objIn = objFile.OpenAsTextStream();

  objRS.Open( 'Mailbox', strConnect, adOpenDynamic, adLockOptimistic, adCmdTable );

  while ( !objIn.AtEndOfStream ) {

    var to = new String( objIn.ReadLine() );
    var from = objIn.ReadLine();
    var subject = objIn.ReadLine();
    var message = objIn.ReadLine();

    objRS.AddNew();
    objRS('name') = to.toUpperCase();
    objRS('to') = to;
    objRS('from') = from;
    objRS('title') = subject;
    objRS('message') = message;
    objRS('read') = false;

  }

  objRS.Update();
  objRS.Close();

%>

Done.