//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//
//  Menu.js
//
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

var TOP = 35;
var nn = (navigator.appName == 'Netscape');
var nn4 = (nn && !document.getElementById);
var ie = (navigator.appName == 'Microsoft Internet Emplorer');
var nn6 = (nn && !nn4);
var menuOpen = false;
var openMenuName;

//////////////////////////////////////////////////////////////////
//
//  MenuArray()
//
//////////////////////////////////////////////////////////////////

function MenuArray() {

  this.items = new Array();

  this.add = menuArray_add;
  this.hideAll = menuArray_hideAll;
  this.showMenu = menuArray_showMenu;
  this.build = menuArray_build;

}

//////////////////////////////////////////////////////////////////
//
//  Menu(left)
//
//////////////////////////////////////////////////////////////////

function Menu(left) {

  this.left = setOffset(left);
  this.top = TOP;

  this.items = new Array();
  this.seperator = menu_seperator;
  this.add = menu_add;
  this.show = menu_show;
  this.hide = menu_hide;

}

//////////////////////////////////////////////////////////////////
//
//  MenuItem(name,url)
//
//////////////////////////////////////////////////////////////////

function MenuItem(name,url) {

  this.name = name;
  this.url = url;

  if (this.url.indexOf('javascript:') != 0) { this.url = getBase() + this.url; }

}

//////////////////////////////////////////////////////////////////
//
//  Point(x,y)
//
//////////////////////////////////////////////////////////////////

function Point(x,y) {

  this.x = x;
  this.y = y;

}

//////////////////////////////////////////////////////////////////
//
//  menu_seperator()
//
//////////////////////////////////////////////////////////////////

function menu_seperator() {

  this.add('','');

}

//////////////////////////////////////////////////////////////////
//
//  menuArray_hideAll()
//
//////////////////////////////////////////////////////////////////

function menuArray_hideAll() {

  for (var i=0; i<this.items.length; i++) {
    var objMenu = this.items[i];
    objMenu.hide();
  }

}

//////////////////////////////////////////////////////////////////
//
//  menu_show()
//
//////////////////////////////////////////////////////////////////

function menu_show() {

  objMenuArray.hideAll();

  var docObjMenu = getDocObjMenu(this.name);
  var objOffset = getOffset();

  var NN6Fix = (document.getElementById) ? 'px' : '';

  docObjMenu.left = objOffset.x + this.left +NN6Fix;
  docObjMenu.top = objOffset.y + this.top +NN6Fix;
  docObjMenu.visibility = 'visible';

  menuOpen = true;
  openMenuName = this.name;

}

//////////////////////////////////////////////////////////////////
//
//  menu_hide()
//
//////////////////////////////////////////////////////////////////

function menu_hide() {

  var docObjMenu = getDocObjMenu(this.name);
  docObjMenu.visibility = 'hidden';

  menuOpen = false;

}

//////////////////////////////////////////////////////////////////
//
//  menu_add(name,url)
//
//////////////////////////////////////////////////////////////////

function menu_add(name,url) {

  this.items[this.items.length] = new MenuItem(name,url);

}

//////////////////////////////////////////////////////////////////
//
//  menuArray_add(Menu)
//
//////////////////////////////////////////////////////////////////

function menuArray_add(Menu) {

  var i = this.items.length;
  this.items[i] = Menu;
  this.items[i].name = i;

}

//////////////////////////////////////////////////////////////////
//
//  menuArray_showMenu(index)
//
//////////////////////////////////////////////////////////////////

function menuArray_showMenu(index) {

  var objMenu = this.items[index];
  objMenu.show();

}

//////////////////////////////////////////////////////////////////
//
//  menuArray_build()
//
//////////////////////////////////////////////////////////////////

function menuArray_build() {

  var menuCSS = 'position: absolute;' +
                'visibility: hidden;' +
                'background-image: url(' +getBase()+ 'files/images/site/back.gif);' +
                'layer-background-color: #000000;' +
                'border: 2px #ff0000 solid;' +
                'font-family: arial,helvetica,verdana;' +
                'font-size: 11pt;' +
                'font-weight: bold;' +
                'padding: 5px;' +
                'color: #ffffff;' +
                'width: 150px;';

  //
  //  draw CSS...
  //

  document.writeln('<style type="text/css">');
  for (var i=0; i<this.items.length; i++) {

    var objMenu = this.items[i];
    document.writeln('#menu' +objMenu.name+ ' {' +menuCSS+ '}');

  }
  document.writeln('</style>');

  //
  //  draw the menus...
  //

  for (var i=0; i<this.items.length; i++) {

    var objMenu = this.items[i];
    var nn4OpenFix = (nn4) ? '<p align="right">' : '';
    var nn4CloseFix = (nn4) ? '</p>' : '';
    document.writeln( '<div onmouseout="hideMenu(' +i+ ')" onmouseover="showMenu(' +i+ ')" class="popup_menu" id="menu' +objMenu.name+ '" align="right">' +nn4OpenFix );

    for (var j=0; j<objMenu.items.length; j++) {

      var objMenuItem = objMenu.items[j];
      var newLine = ( j+1 < objMenu.items.length ) ? '<br />' : '';
      document.write( '<a onmouseover="showMenu(' +i+ ')" class="popupMenuItem" href="' +objMenuItem.url+ '">' +objMenuItem.name+ '</a>' +newLine );

    }

    document.writeln( nn4CloseFix+ '</div>' );

    if (nn4) eval( 'document.menu' +i+ '.onmouseout = hideMenu;' );

  }
}

//////////////////////////////////////////////////////////////////
//
//  getOffset() : Point
//
//////////////////////////////////////////////////////////////////

function getOffset() {

  if (is_ie()) {

    return new Point(document.body.clientWidth - 580,86);

  } else if (document.layers) {

    var objDocItem = document.menu_image;
    return new Point(objDocItem.x,objDocItem.y);

  } else if (document.getElementById) {

    return new Point(160,60);

  } else {

    return new Point(100,100);

  }

}

//////////////////////////////////////////////////////////////////
//
//  getDocObjMenu(id)
//
//////////////////////////////////////////////////////////////////

function getDocObjMenu(id) {
  if (document.all) {
    return eval('document.all.menu' +id+ '.style');
  } else if (document.layers) {
    return eval('document.menu' +id);
  } else {
    return document.getElementById('menu'+id).style;
  }
}

//////////////////////////////////////////////////////////////////
//
//  setOffset(offset) : offset
//
//////////////////////////////////////////////////////////////////

function setOffset(offset) {

  if (is_nn()) {
    return offset + 30;
  } else {
    return offset;
  }

}

//////////////////////////////////////////////////////////////////
//
//  hideMenu( topName, index )
//
//////////////////////////////////////////////////////////////////

function hideMenu( index ) {

  index = (index == '[object Event]') ? openMenuName : index;

  var objMenu = objMenuArray.items[index];
  objMenu.hide();

}

//////////////////////////////////////////////////////////////////
//
//  showMenu( index )
//
//////////////////////////////////////////////////////////////////

function showMenu( index ) {

  var objMenu = objMenuArray.items[index];
  objMenu.show();

}

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

var objMenuArray = new MenuArray();

var objMenuProfiles = new Menu(46);
objMenuProfiles.add('register','06.pl');
objMenuProfiles.add('create','04.pl?todo=create');
objMenuProfiles.add('edit','javascript:editProfile()');
objMenuProfiles.add('delete','05.pl');
objMenuProfiles.add('password','13.pl');
objMenuProfiles.add('colors','04.pl?todo=color');
objMenuProfiles.add('stats','12.pl');
objMenuProfiles.seperator();
objMenuProfiles.add('a-i','04.pl?todo=list|from=A|to=I');
objMenuProfiles.add('j-r','04.pl?todo=list|from=J|to=R');
objMenuProfiles.add('s-rest','04.pl?todo=list|from=S|to=REST');
objMenuArray.add(objMenuProfiles);

var objMenuBirthdays = new Menu(205);
objMenuBirthdays.add('add yours','08.pl?todo=add');
objMenuBirthdays.add('remove','08.pl?todo=delete');
objMenuBirthdays.seperator();
objMenuBirthdays.add('january','08.pl?todo=view|month=january|index=1|days=31');
objMenuBirthdays.add('february','08.pl?todo=view|month=february|index=2|days=29');
objMenuBirthdays.add('march','08.pl?todo=view|month=march|index=3|days=31');
objMenuBirthdays.add('april','08.pl?todo=view|month=april|index=4|days=30');
objMenuBirthdays.add('may','08.pl?todo=view|month=may|index=5|days=31');
objMenuBirthdays.add('june','08.pl?todo=view|month=june|index=6|days=30');
objMenuBirthdays.add('july','08.pl?todo=view|month=july|index=7|days=31');
objMenuBirthdays.add('august','08.pl?todo=view|month=august|index=8|days=31');
objMenuBirthdays.add('september','08.pl?todo=view|month=september|index=9|days=30');
objMenuBirthdays.add('october','08.pl?todo=view|month=october|index=10|days=31');
objMenuBirthdays.add('november','08.pl?todo=view|month=november|index=11|days=30');
objMenuBirthdays.add('december','08.pl?todo=view|month=december|index=12|days=31');
objMenuArray.add(objMenuBirthdays);

var objMenuPages = new Menu(263);
objMenuPages.add('apply','03.pl?todo=contact');
objMenuArray.add(objMenuPages);

var objMenuMsgboard = new Menu(356);
objMenuMsgboard.add('view','msgboard');
objMenuMsgboard.add('post','msgboard/nocache.pl#post');
objMenuMsgboard.add('communal','msgboard/communal.pl');
objMenuMsgboard.add('login','msgboard/login.pl');
objMenuArray.add(objMenuMsgboard);

var objMenuOther = new Menu(405);
objMenuOther.add('contact','03.pl?todo=contact');
objMenuOther.add('help','02.pl?todo=help');
objMenuOther.add('search board','02.pl?todo=board');
objMenuOther.add('search profiles','02.pl?todo=profiles');
objMenuOther.add('links','03.pl?todo=links');
objMenuOther.seperator();
objMenuOther.add('images','images');
objMenuOther.add('music','music');
objMenuOther.add('webring','webring');
objMenuOther.add('journals','journals');
objMenuOther.add('bookclub','bookclub');
objMenuOther.add('javachat','javachat');
objMenuOther.add('hotornot','hotornot');
objMenuOther.add('profiles guide','04.pl#ProfilesGuide');
objMenuArray.add(objMenuOther);

var objMenuMailbox = new Menu(123);
objMenuMailbox.add('login','09.pl');

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////