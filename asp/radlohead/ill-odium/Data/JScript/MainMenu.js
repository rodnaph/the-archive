///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//
//  MainMenu.js
//
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

// object types
var MenuTypes = {
  MENU : 0,
  ITEM : 1
};

// visibility types
var Visibility = {
  VISIBLE : 'visible',
  HIDDEN : 'hidden'
};

// error message
var Errors = {
  MENU_NOT_BUILT : 'The menu has not been built'
};

// globals
var _Menu_collapseID = null;
var _Menu_IDs = 1;
var _Menu_objNodes = new Array();

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : Menu()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Menu( title, x, y ) {

  // private properties
  this.$title = title;
  this.$x = x;
  this.$y = y;
  this.$id = 'Menu' +_Menu_IDs++;
  this.$created = false;
  this.$type = MenuTypes.MENU;
  this.$items = new Array();
  this.$isOpen = false;
  this.$isRoot = false;

  // private methods
  this.$isMenu = _Menu_isMenu;
  this.$hideAll = _Menu_hideAll;
  this.$setVisibility = _Menu_setVisibility;

  // public properties
  this.backgroundColor = 'eeeeee';
  this.width = 120;
  this.itemHeight = 21;

  // public methods
  this.show = _Menu_show;
  this.hide = _Menu_hide;
  this.add = new Function( 'objItem', 'this.$items.push( objItem )' );
  this.build = _Menu_build;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : Item()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Item( title, action ) {

  // private properties
  this.$title = title;
  this.$action = action;
  this.$type = MenuTypes.ITEM;

  // private methods
  this.$isMenu = _Menu_isMenu;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_isMenu()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_isMenu() {

  return ( this.$type == MenuTypes.MENU ) ? true : false;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_hideAll()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_hideAll() {

  for ( var i in this.$items ) {

    var objItem = this.$items[i];

    if ( objItem.$isOpen )
      objItem.hide();

  }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_show()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_show() {

  if ( this.$created ) {

    if ( this.$isRoot )
      collapseRoots();

    this.$hideAll();
    this.$setVisibility( Visibility.VISIBLE );
    this.$isOpen = true;

  }
  else error( Errors.MENU_NOT_BUILT );

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_hide()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_hide() {

  if ( this.$created ) {

    this.$hideAll();
    this.$setVisibility( Visibility.HIDDEN );
    this.$isOpen = false;

  }
  else error( Errors.MENU_NOT_BUILT );

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_setVisibility( type )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_setVisibility( type ) {

  var objStyle = fetchStyleObject( this.$id );
  objStyle.visibility = type;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  _Menu_build()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function _Menu_build( objParent, childIndex, objRoot ) {

  this.$created = true;
  _Menu_objNodes.push( this );

  var strShadow = '<table width="' +this.width+ '" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#777777"><td><img src="/ill-odium/Data/Images/spacer.gif" width="2" height="1" /></td></tr></table>' +
                  '<table width="' +this.width+ '" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#aaaaaa"><td><img src="/ill-odium/Data/Images/spacer.gif" width="2" height="1" /></td></tr></table>';


  // set position if menu not root
  if ( objParent != null ) {

    this.$x = objParent.$x + objParent.width - 4;
    this.$y = objParent.$y + ( childIndex * this.itemHeight ) + 2;

    strShadow = '';

  }
  else {
    objRoot = this;
    objRoot.$isRoot = true;
  }

  document.writeln( '<div id="' +this.$id+ '" class="MenuBox" onmouseout="initiateCollapse(\'' +objRoot.$id+ '\')">' +
                    strShadow+
                    '<table width="' +this.width+ '" cellpadding="2" cellspacing="0" border="0">' +
                    '<tr><td>' );

  for ( var i in this.$items ) {

    var objItem = this.$items[i];
    var strImage = ( objItem.$isMenu() ) ? 'tri-right' : 'spacer';
    var strAction = ( objItem.$isMenu() ) ? 'javascript:void()' : objItem.$action;
    var strOnMouseOver = ( objItem.$isMenu() ) ? 'expandTree(\'' +this.$id+ '\',\'' +objItem.$id+ '\')'
                                              : 'expandTree(\'' +this.$id+ '\')';

    document.writeln( '<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td ' +
                          ' onmouseover="' +strOnMouseOver+ '" ' +
                      '><a class="MenuItem" href="' +strAction+ '">' +
                      '<img src="/ill-odium/Data/Images/' +strImage+ '.gif" border="0" width="3" height="7" alt="Menu" /> &nbsp;' +
                      objItem.$title+ '</a>' +
                      '</td></tr></table>' );

  }

  document.writeln( '</td></tr></table></div>' );

  // draw children
  for ( var i in this.$items ) {

    var objItem = this.$items[i];
    if ( objItem.$isMenu() ) objItem.build( this, i, objRoot );

  }

  // setup menu
  var objDoc = document.getElementById( this.$id );
  with ( objDoc.style ) {

    position = 'absolute';
    visibility = 'hidden';
    pixelLeft = this.$x;
    pixelTop = this.$y;

  }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  expandTree()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function expandTree( menuID, nodeID ) {

  haltCollapse();

  fetchNode( menuID ).show();

  if ( nodeID != null )
    fetchNode( nodeID ).show();

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  collapseTree()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function collapseTree( nodeID ) {

  fetchNode( nodeID ).hide();

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  initiateCollapse( nodeID )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function initiateCollapse( nodeID ) {

  haltCollapse();

  _Menu_collapseID = setTimeout( 'collapseTree(\'' +nodeID+ '\')', 500 );

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  haltCollapse()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function haltCollapse() {

  if ( _Menu_collapseID != null )
    clearTimeout( _Menu_collapseID );

  _Menu_collapseID = null;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  collapseRoots()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function collapseRoots() {

  for ( var i in _Menu_objNodes ) {

    var objNode = _Menu_objNodes[i];

    if ( objNode.$isRoot && objNode.$isOpen ) objNode.hide();

  }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  fetchNode( nodeID )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function fetchNode( nodeID ) {

  for ( var i in _Menu_objNodes ) {

    var objNode = _Menu_objNodes[i];
    if ( objNode.$id == nodeID )
      return objNode;

  }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  fetchStyleObject( id )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function fetchStyleObject( id ) {

  return document.getElementById( id ).style;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  error( message )
//
///////////////////////////////////////////////////////////////////////////////////////////////

function error( message ) {

  alert( 'Error: ' +message );

}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////