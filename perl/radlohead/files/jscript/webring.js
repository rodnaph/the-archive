///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//
//  webring.js
//
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  getCode( id )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function getCode( id ) {

  var win = window.open( '', 'codeWin', 'toolbars=no,scrollbars=no,width=600,height=310,left=50,top=50' );
  var doc = win.document;
  var code = '<html><head><title>Webring Code</title><link href="/files/css/ie.css" rel="stylesheet" type="text/css" />' +
             '<style type="text/css">A{text-decoration:none;}BODY,P,TD,H2{font-family:arial,helvetica,verdana;}T,TD{ font-size:10pt;}</style>' +
             '</head><body bgcolor="#000000" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF" background="/files/images/site/back.gif">' +
             '<h3>Webring Code</h3><p>Just copy and paste from the textarea below.  Easy.</p>' +
             '<textarea cols="70" rows="10">' +

             '<a href="http://www.radlohead.com/webring/webring.pl?todo=prev&id=' +id+ '" target="_top">prev</a> -' +
             '<a href="http://www.radlohead.com/webring/webring.pl?todo=random" target="_top">random</a> -' +
             '<a href="http://www.radlohead.com/webring/webring.pl?todo=list" target="_top">list</a> -' +
             '<a href="http://www.radlohead.com/webring/webring.pl?todo=next&id=' +id+ '" target="_top">next</a>' +

             '</textarea><p><a href="javascript:window.close()">close window</a></p></body></html>';

  doc.open();
  doc.writeln( code );
  doc.close();

}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////