/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//
//  preLoader.js
//
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//
//  createImage(dir,name) : Image
//
/////////////////////////////////////////////////////////////////////

function createImage(dir,name) {
  var img = new Image();
  img.src = getBase() + dir + name;
  return img;
}

/////////////////////////////////////////////////////////////////////
//
//  createMenuInfoImage(imageName) : Image
//
/////////////////////////////////////////////////////////////////////

function createMenuInfoImage(imageName) {
  return createImage('files/images/menu_info/',imageName+'.gif');
}

/////////////////////////////////////////////////////////////////////
//
//  createMenuImage(imageName) : Image
//
/////////////////////////////////////////////////////////////////////

function createMenuImage(imageName) {
  return createImage('files/images/menu/','menu_'+imageName+'.gif');
}

/////////////////////////////////////////////////////////////////////
//
//  pre-loading menu_info images
//
/////////////////////////////////////////////////////////////////////

var ProfilesImg = createMenuInfoImage('profiles');
var MailboxImg = createMenuInfoImage('mailbox');
var BirthdaysImg = createMenuInfoImage('birthdays');
var PagesImg = createMenuInfoImage('pages');
var MsgboardImg = createMenuInfoImage('msgboard');
var OtherImg = createMenuInfoImage('site');
var blankInfoImg = createMenuInfoImage('blank');

var menuBlankImg = createMenuImage('image');
var menuProfilesImg = createMenuImage('profiles');
var menuMailboxImg = createMenuImage('mailbox');
var menuBirthdaysImg = createMenuImage('birthdays');
var menuPagesImg = createMenuImage('pages');
var menuMsgboardImg = createMenuImage('msgboard');
var menuOtherImg = createMenuImage('other');

// view/leave comment images
var viewOffImg = createImage( 'files/images/site/', 'viewcomments.gif');
var viewOverImg = createImage( 'files/images/site/', 'viewcomments_over.gif');
var leaveOffImg = createImage( 'files/images/site/', 'leavecomments.gif' );
var leaveOverImg = createImage( 'files/images/site/', 'leavecomments_over.gif' );

/////////////////////////////////////////////////////////////////////