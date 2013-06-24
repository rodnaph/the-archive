<%@ language="jscript" @%>

<!--#include virtual="/Data/Inc/Config.asp"-->
<!--#include virtual="/Data/Inc/WebringHeader.asp"-->

<%

  var id = Request('id');
  var objWebring = Server.CreateObject( 'ADODB.RecordSet' );

  if ( !isNaN(id) ) {

    objWebring.Open( 'Webring', strConnect, adOpenDynamic );
    objWebring.Find( 'id = ' +id );

    if ( !objWebring.EOF && !objWebring.BOF ) {

      objWebring.MovePrevious();
      if ( objWebring.BOF ) objWebring.MoveLast();
      Response.Redirect( objWebring('url') );

    }
    else error();

  }
  else error();

%>