##################################################
##################################################
##
##  02.pl
##
##################################################
##################################################

use strict;

use constant BASE => 'd:/sites/radlohead/Archive/2002/';
#use constant BASE => 'f:/newmind/radiohead/';
use constant HELP_DIR => BASE . 'files/help/';
use constant PROFILES_DB => BASE . 'files/db/profiles.db';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle;
use DirHandle;
use Benchmark;
use Dispatch;
use Request;
use HashDatabase;

##################################################

require 'output.lib';

##################################################

my $q = new Request;

my $dispatch = new Dispatch( \&draw_page );
$dispatch->load(
                 -help =>\&help_form,
                 -search_help => \&search_help,
                 -searchBoard => \&archive,
                 -searchProfiles => \&archive,
                 -board => \&board_form,
                 -profiles => \&profiles_form,
                );

##################################################

##################################################
##
##  main
##
##################################################

header("Search");
open_tr();

##
##  dispatching
##

$dispatch->execute( $q->param("todo") );

footer();

##################################################
##
##  help_form( value )
##
##################################################

sub help_form {

  my ( $value ) = @_;

  start_box("Search For Help");
  print_text("<p>If you are stuck with something and don't want to contact us about it then " .
             "just put your problem into the form below and search for some help.</p>");

  start_form("02.pl");
  hidden_field("todo","search_help");
  text_field("problem","keys",'','',$value);  
  end_form("SEARCH");
  end_box();

}

##################################################
##
##  search_help()
##
##################################################

sub search_help {

  my $key = $q->param("keys");
  my $ra_matches;

  my $dh = new DirHandle(HELP_DIR);
  while(my $file = $dh->read()) {

    my $fh = new FileHandle(HELP_DIR . $file);
    while (my $line = <$fh>) {
      if ($line =~ /$key/) {
        push(@$ra_matches,$file);
        last;
      }
    }

  }
  $dh->close();

  ##
  ##  print results...
  ##

  start_box("Search Results");
  print_text("The following help files were found which contain the key <i>$key</i>\n<br /><br />");

  foreach my $match (@$ra_matches) {
    $match =~ s/\.txt//i;
    print_text("<a href=\"15.pl?topic=$match\"><b>$match</b></a><br />\n");
  }

  if (!@$ra_matches) { print_text("Sorry, but no matches were found"); }
  end_box();

  help_form( $key );

}

##################################################
##
##  board_form( value )
##
##################################################

sub board_form {

  my ( $value ) = @_;

  my $text = <<EOT;

<p>If you want to find someones posts on the message board, or look for something
specific, just stick it in the form and click <b>SEARCH</b></p>

EOT

  start_box('Searching the Board');
  print_text($text);

  start_form("02.pl");
  hidden_field("todo","searchBoard");
  text_field("key","key",'','',$value);
  end_form("SEARCH");
  end_box();

}

##################################################
##
##  profiles_form( value )
##
##################################################

sub profiles_form {

  my ( $value ) = @_;

  start_box("Searching the Profiles");

  my $text = <<EOT;

<p>If you want to find someone with specific interests, location, whatever...just
stick something in the form below and click search to search all the profiles
stored on the system.</p>

EOT

  print_text($text);

  start_form("02.pl");
  hidden_field("todo","searchProfiles");
  text_field("keywords","keywords",'','',$value);
  end_form("SEARCH");
  end_box();

}

##################################################
##
##  search_board()
##
##################################################

sub search_board {

  my ($key,@matches) = ($q->param("key"));

  ##
  ##  GET MATCHES
  ##

  my $start = new Benchmark;

  {
    my $fh = new FileHandle(BASE . "msgboard/posts.nfo");
    while(<$fh>) {
      if (/$key/i) { push(@matches,$_); }
    }
    $fh->close();
  }

  my $end = new Benchmark;
  my $benchmark = timediff($end,$start);

  ##
  ##  OUTPUT
  ##

  my ($time) = timestr($benchmark);

  start_box("Board Search Results");

  my $text = <<EOT;

<i>the search was performed using the key "$key"<br>
the search took <b>$time</b> seconds
</i>
<br /><br />

EOT

  print_text($text);

  if (@matches) {

    foreach my $match (@matches) {
      $match =~ s/<span style="color:#(000000|000)">/<span style="color:#FFFFFF">/g;
      chomp($match);
      print_text($match);
    }

  } else {

    print_text("Sorry, but there was nothing found matching your requirements");

  }

  end_box();

  board_form( $key );

}

##################################################
##
##  search_profiles()
##
##################################################

sub search_profiles {

  my $db = new HashDatabase;
  my %matches;
  my $top = 0;
  my @keys;
  my $keys = uc( $q->param('keywords') );

  ##
  ##  process results...
  ##

  $keys =~ s/([A-Za-z]*)/ push( @keys, uc($1) ) /eg;
  $db->open( PROFILES_DB );

  foreach my $key ( @keys ) {
    if ( $key ) {
      my @files = split( /:#:/, $db->value($key) );
      foreach my $match ( @files ) {
        if ( $match ) {
          $matches{$match} += 1;
          $top = $matches{$match} unless $matches{$match} < $top;
        }
      }
    }
  }

  $db->close();

  my $no_of_keys = 0;
  foreach my $key ( @keys ) {
   if ( $key ) { $no_of_keys++; }
  }

  ##
  ##  drawing...
  ##

  start_box( 'Search Results' );
  print_text( '<p>The results of your search using the key "<b>' . $q->param('keywords') . '</b>" are...</p>' );

  my $drawn = 0;

  for ( my $i=$top; ($i>0) && ($drawn < 50); $i-- ) {
    foreach my $key ( keys %matches ) {
      if ( $matches{$key} eq $i ) {

        $drawn++;
        my $match = ($matches{$key} / $no_of_keys) * 100;

        print <<EOT;

@{[ user_html( URLDecode($key) ) ]} <small>$match%</small><br />

EOT

      }
    }
  }

  end_box();

  profiles_form( $q->param('keywords') );

}

##################################################
##
##  draw_page()
##
##################################################

sub draw_page {

  my $text = <<EOT;

<p>If you want to find some stuff here at radlohead.com then we've got a nifty
little search facility set up so you can do just that.</p>

<p>Wanna search our message board to make sure there's no interesting
posts you missed ??  Wanna search the profiles stored on the system to
find other boarders with similar intersts, etc...??</p>

<p>Well you can do both of these, just click the relevant link above on the
left and follow the instructions.</p>

<p>:D</p>

EOT

  print_box('Searching', $text);

}

##################################################
##################################################