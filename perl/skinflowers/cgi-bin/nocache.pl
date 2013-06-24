#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  nocache.pl
##
###############################################################################################
###############################################################################################

use strict;
use FileHandle qw( getline );
use CGI;

###############################################################################################

use constant BASE => '../www/msgboard/';
use constant BOARD => BASE . 'msgboard.html';
use constant POSTS => BASE . 'posts/';

###############################################################################################

my $q = new CGI;
my $content;

###############################################################################################

if ( my $post = $q->param('post') ) {

  ##
  ##  viewing a particular post...
  ##

  $content = get_content( POSTS . $post . '.html' );

  $content =~ s/\/msgboard\/posts\/..\/msgboard\.html/\/cgi-bin\/nocache.pl/;
  $content =~ s/\/msgboard\/msgboard\.html/\/cgi-bin\/nocache.pl/g;
  $content =~ s/\/msgboard\/posts\/(\d+)\.html/\/cgi-bin\/nocache.pl?post=$1/;

  $content =~ s/(<input type="hidden")/<input type="hidden" name="nocache" value="yes" \/>$1/;
  $content =~ s/(\d+)\.html/\/cgi-bin\/nocache.pl?post=$1/g;

} else {

  ##
  ##  draw the main board page...
  ##

  $content = get_content( BOARD );

  $content =~ s/(<input type="submit")/<input type="hidden" name="nocache" value="1" \/>$1/;
  $content =~ s/href="posts\/(\d+)\.html"/href="\/cgi-bin\/nocache.pl?post=$1"/g;

}

send_content( $content );

###############################################################################################
##
##  send_content( content )
##
###############################################################################################

sub send_content {

  my ( $content ) = @_;

  print $q->header( -type => 'text/html' ),
        $content;

}

###############################################################################################
##
##  get_content( filename )
##
###############################################################################################

sub get_content {

  my ( $filename ) = @_;

  local $/ = undef;

  my $fh = new FileHandle( $filename );
  return $fh->getline();

}

###############################################################################################