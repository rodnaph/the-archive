
// browsers
var nn = ( navigator.appName == 'Netscape' ) ? 1 : 0;
var nn6 = ( nn && document.getElementById ) ? 1 : 0;
var nn4 = ( nn && document.layers ) ? 1 : 0;
var op = ( navigator.userAgent.indexOf('Opera') != -1 ) ? 1 : 0;
var ie = ( !op && document.all ) ? 1 : 0;

if ( !document.getElementById )
  document.getElementById = getElementById;

function getElementById( id ) {

  if ( nn4 )
    return document.layers[id];
  else
    return document.all[id];

}

// events a tile generates
var TileEvents = new Array( 'mouseover' );

var Tiles = {

  SIZE : 30,
  ID : 0,
  nextID : new Function( 'return this.ID++' ),
  tiles : new Array(),

  getTile : Tiles_getTile

};

function Tiles_getTile( x, y ) {

  for ( var i in this.tiles ) {
    var tile = this.tiles[i];
    if ( tile.x == x && tile.y == y ) return tile;
  }

  return null;

}

function Tile( x, y, grid ) {

  // properties
  this.x = x;
  this.y = y;
  this.grid = grid;
  this.id = Tiles.nextID();
  this.document = null;
  this.intervalID = null;
  this.position = Tiles.tiles.length;

  // add tile to collection
  Tiles.tiles.push( this );

  // methods
  this.create = Tile_create;
  this.setColor = Tile_setColor;

  // attach events
  for ( var i in TileEvents )
    eval( 'this.' +TileEvents[i]+ ' = new Function(\'\');' );

}

function Tile_create() {

  var tag = ( nn4 ) ? 'layer' : 'div';
  document.writeln( '<' +tag+ ' id="' +this.id+ '">&nbsp;</' +tag+ '>' );

  this.document = document.getElementById( this.id );

  // attache event handlers
  this.document.onmouseover = new Function( 'Tiles.tiles[' +this.id+ '].mouseover()' );

  if ( ie ) {
   with ( this.document.style ) {

    position = 'absolute';
    pixelLeft = this.x;
    pixelTop = this.y;
    width = Tiles.SIZE;
    height = Tiles.SIZE;
    backgroundColor = '#ff0000';
    fontFamily = 'verdana';
    fontSize = '1pt';

   }
  }

  if ( nn4 ) {

    this.document.bgcolor = '#ff0000';
    this.moveTo( this.x, this,y );

  }

}

function Tile_setColor( color ) {

  if ( nn4 )
    this.document.bgcolor = color;
  else
    this.document.style.backgroundColor = color;

}

