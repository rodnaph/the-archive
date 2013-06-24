###############################################################################################
###############################################################################################
##
##  nocache.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use LWP::Simple;
use Request;

###############################################################################################

require 'msgboard.lib';

###############################################################################################

my $q = new Request;
my $server = 'www.radiohead.com';
#my $server = '212.111.52.227';

###############################################################################################

msgboard_header('Official Board');

###############################################################################################
##
##  show a particular post...
##
###############################################################################################

if ( my $number = $q->param('post') ) {

  if ( $number eq 'latest' ) {
    $number = get( "http://$server/msgboard/data.txt" );
  }

  my $url = "http://$server/msgboard/messages/$number.html";
  my $post = get( $url );

  if ( $post ) {

    my $page = get_page();

    (my $fst, $post ) = split( /vlink="666666">/, $post );
    $post =~ s/href="(\d+).html"/href="nocache.pl?post=$1|page=$page"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/help.html"/href="help.pl"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="nocache.pl?page=$page"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="nocache.pl?post=$1|page=$page"/g;
    $post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="post.pl"/;
    $post =~ s/<\/body><\/html>//;
    $post = edit_threads( $post );
    $post = edit_colors( $post );

    print $post;

  }
  else {

    print_box('Board Error', "Post $number not found at $url" );

  }

}

###############################################################################################
##
##  else draw the main page...
##
###############################################################################################

else {

  my $page = get_page();
  my $url = "http://$server/msgboard/msgboard$page.html";
  my $board = get( $url );

  if ( $board ) {

    ( my $fst, $board ) = split( /_________________________<p>/, $board );
    $board =~ s/href="msgboard(\d+).html"/href="nocache.pl?page=$1"/g;
    $board =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="nocache.pl?post=$1|page=$page"/g;
    $board =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="post.pl"/;
    $board =~ s/<\/body><\/html>//;
    $board = edit_threads( $board );
    $board = edit_colors( $board );

    print $board;

  }
  else {

    print_box('Board Error', "Message Board Page $page not found at $url");

  }

}

footer();

###############################################################################################
##
##  edit_threads( html )
##
###############################################################################################

sub edit_threads {

  my ( $html ) = @_;

  $html =~ s/\(<!--responses: \d+-->\d+\)//g;
  $html =~ s/<\/b> \d+\/\d+\/\d+/<\/b>/g;

  return $html;

}

###############################################################################################
##
##  get_page()
##
###############################################################################################

sub get_page {

  return ($q->param('page')) ? $q->param('page') : 1;

}

###############################################################################################
##
##  edit_colors( html )
##
###############################################################################################

sub edit_colors {

  my ( $html ) = @_;

  $html =~ s/color="000000"/color="ffffff"/g;

  return $html;

}

###############################################################################################
###############################################################################################