///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//
//  MenuSource.js
//
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

var portMore = new Menu( 'Message Boards' );
portMore.add( new Item( 'dboard', 'http://m0ren0.hypermart.net/dboard' ) );
portMore.add( new Item( 'Eris', 'http://m0ren0.hypermart.net/eris') );
portMore.add( new Item( 'FlipTheFish', 'http://www.flipthefish.com' ) );

var skinfl = new Menu( 'Skinflowers.org' );
skinfl.add( new Item( 'About', '' ) );
skinfl.add( new Item( 'Website', 'http://www.skinflowers.org' ) );

var radl = new Menu( 'Radlohead.com' );
radl.add( new Item( 'About', '' ) );
radl.add( new Item( 'Website', 'http://www.radlohead.com' ) );

var climbi = new Menu( 'Climbing Up The Walls' );
climbi.add( new Item( 'About', '' ) );
climbi.add( new Item( 'Website', 'http://www.climbingupthewalls.com' ) );

var portf = new Menu( '', 122, 28 );
portf.add( skinfl );
portf.add( radl );
portf.add( climbi );
portf.add( portMore );
portf.width = 180;
portf.build();

var projects = new Menu( '', 70, 28 );
projects.add( new Item('Menu','/ill-odium/Projects/Demos/Menu') );
projects.add( new Item('FileBrowser','/ill-odium/Projects/Demos/FileBrowser') );
projects.add( new Item('Menu Builder','/ill-odium/Projects/Demos/MenuBuilder') );
projects.build();


var submail2 = new Menu( 'Sub Mail 2' );
submail2.add( new Item('Nothing..','') );
submail2.add( new Item('..Very..','') );
submail2.add( new Item('..Much','') );

var mailbox2 = new Menu( 'Mailbox 2' );
mailbox2.add( new Item('Login','qwe') );
mailbox2.add( new Item('Logout','qwe') );
mailbox2.add( new Item('Inbox','qwe') );
mailbox2.add( submail2 );
mailbox2.add( new Item('COmpose','qwe') );


var submail = new Menu( 'Sub Mail' );
submail.add( new Item('Nothing..','') );
submail.add( new Item('..Very..','') );
submail.add( new Item('..Much','') );

var mailbox = new Menu( 'Mailbox' );
mailbox.add( new Item('Login','qwe') );
mailbox.add( new Item('Logout','qwe') );
mailbox.add( new Item('Inbox','qwe') );
mailbox.add( submail );
mailbox.add( new Item('COmpose','qwe') );

var main = new Menu( 'Main', 8,28 );
main.add( new Item('Another','qwe') );
main.add( mailbox2 );
main.add( new Item('Profiles', 'asd') );
main.add( new Item('Birthdays', 'asd') );
main.add( mailbox );
main.add( new Item('Something','zxc') );

main.build();

//alert('DONE');

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////