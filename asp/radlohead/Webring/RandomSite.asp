<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->

<%

  var objWebring = Server.CreateObject( 'ADODB.RecordSet' );
  var url = null;

  objWebring.Open( 'Webring', strConnect, adOpenDynamic );
  objWebring.MoveLast();

  var max = objWebring('id') / 1;

  while ( url == null ) {

    var index = 1 + (Math.round( Math.random() * 1000 ) % max);

    objWebring.Find( 'id = ' +index );

    if ( !objWebring.EOF && !objWebring.BOF )
      url = '' + objWebring('url');
    else
      objWebring.MoveFirst();

  }

  Response.Redirect(index);

%>