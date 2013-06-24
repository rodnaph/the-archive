###############################################################################################
###############################################################################################
##
##  communal.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant COMMUNAL_NAMES => BASE . 'files/communal_names';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline print );
use Request;
use Dispatch;

###############################################################################################

require 'msgboard.lib';
require 'output.lib';

###############################################################################################

my $q = new Request;
my $d = new Dispatch;

###############################################################################################

msgboard_header( 'Communal Names' );

$d->load(
         -add => \&add_name,
         -post => \&make_post
        );

$d->execute( $q->param('todo') );

footer();

###############################################################################################
##
##  new_name( name )
##
###############################################################################################

sub new_name {

  my ( $name ) = @_;

  my $fh = new FileHandle( COMMUNAL_NAMES );

  while( my $line = $fh->getline() ) {
    if ( $line =~ /$name:#:/i ) { return 0; }
  }

  return 1;

}

###############################################################################################
##
##  add_name()
##
###############################################################################################

sub add_name {

  ##
  ##  add the name...
  ##

  my $name = $q->param('username');
  my $pass = $q->param('password');

  if ( new_name($name) ) {

    my $fh = new FileHandle( COMMUNAL_NAMES, '>>' );
    $fh->print( "$name:#:$pass\n" );

  }

  my $text = <<EOT;

<p>
Success, you have added the communal name <b>$name</b> to our system.  Others can now easily post
using this communal name on the official radiohead message board.
</p>

EOT

  print_box( 'Communal Name Added', $text );

}

###############################################################################################
##
##  make_post()
##
###############################################################################################

sub make_post {

  my $name = $q->param('name');
  my $pass = $q->param('pass');

  my $text = <<EOT;

<p>
To post a message using the communal name <b>$name</b> just fill out the required
fields below and click POST.
</p>

<form method="POST" action="post.pl">
  <input type="hidden" name="name" value="$name" />
  <input type="hidden" name="pass" value="$pass" />
COLOUR: <br> <select name="mycolour" tabindex="1"><option>Black
<option>Turquoise
<option>Violet
<option>Shocking Pink
<option>Peachy
<option>Grey
<option>Maroon
<option>Brown
<option>Emerald
<option>Lime Green
<option>Radiant Orange
<option>Purpley
<option>Lemon
<option>Scarlet
<option>White
</select><br><br>
E-MAIL (optional):<br> <input tabindex="2" type=text name="email" value="" size=50><br><br>
SUBJECT:<br> <input tabindex="3" type=text name="subject" value="" size="50" maxlength="50"><br><br>
MESSAGE:<br>
<textarea tabindex="6" COLS=55 ROWS=10 name="body" wrap=virtual></textarea><br><br>
<input type=submit tabindex="7" value="POST MESSAGE"> <input type=reset>
</form>

EOT

  print_box( "Posting As $name", $text );

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  my $text = <<EOT;

<p>
This small section is here to provide somewhere for communal board names to be stored and
looked up.  If you know of a communal name that isn't currently on the list then just use
the form at the bottom of the page to add it.
</p>

<p>
For the names that are on the list, you can just click on them to use them to post a new
message on the official radiohead message board.  Easy.
</p>

<blockquote>

EOT

  my $fh = new FileHandle( COMMUNAL_NAMES );

  while ( my $line = $fh->getline() ) {

    chomp( $line );
    my ( $name, $pass ) = split( /:#:/, $line );

    $text .= <<EOT;

<a href="communal.pl?todo=post|name=@{[ URLEncode($name) ]}|pass=@{[ URLEncode($pass) ]}">$name</a>
- <i>($pass)</i>
<br />

EOT
  }

  $text .= <<EOT;

</blockquote>

<p>
If you have any problems or questions just look into the help section or get in
touch with us.
</p>

EOT

  print_box( 'Communal Names', $text );

  start_box( 'Adding A Communal Name' );

  my $text = <<EOT;

EOT

  print_text( $text );

  start_form( 'communal.pl' );
  hidden_field( 'todo', 'add' );
  text_field( 'username' );
  text_field( 'password' );
  end_form( 'ADD COMMUNAL NAME' );

  end_box();

}

###############################################################################################
###############################################################################################