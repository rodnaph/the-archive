////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//
//  Clock.js
//
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

var intervalID;

////////////////////////////////////////////////////////////
//
//  getDate() : HTML
//
////////////////////////////////////////////////////////////

function getDate() {

  var now = new Date();

  var hours = now.getHours();
  var minutes = now.getMinutes();
  var seconds = now.getSeconds();
  var AmPm = (hours < 12) ? 'am' : 'pm';

  if (minutes < 10) { minutes = '0' +minutes; }
  if (seconds < 10) { seconds = '0' +seconds; }

  return '<font face="arial,helvetica,verdana" size="2"><b>' 
         +hours+ ':' +minutes+ ':' +seconds + AmPm+
         '</b></font>';

}

////////////////////////////////////////////////////////////
//
//  updateClock()
//
////////////////////////////////////////////////////////////

function updateClock() {

  if (document.all) {

    var docObj = document.all.clock;
    docObj.innerHTML = '&nbsp; ' +getDate();

  } else if (document.layers) {

    var docObj = document.layers.clock;
    docObj.x = 25;
    docObj.y = 75;
    docObj.document.open();
    docObj.document.writeln(getDate());
    docObj.document.close();

  }

}

////////////////////////////////////////////////////////////
//
//  startClock()
//
////////////////////////////////////////////////////////////

function startClock() {

  if ((document.all) || (document.layers)) {
    intervalID = setInterval("updateClock()",1000);
  }

}

////////////////////////////////////////////////////////////