###############################################################################################
###############################################################################################
##
##  post.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use LWP::UserAgent;
use HTTP::Headers;
use Request;

###############################################################################################

require 'msgboard.lib';

###############################################################################################

my $q = new Request;
my $server = 'www.radiohead.com';

###############################################################################################

msgboard_header('Official Board');

##
##  assemble arguments...
##

my @formargs = qw( followup origname origsubject origdate name pass mycolour body email subject );
my $qs = '';

foreach my $arg ( @formargs ) {
  if ( $value = $q->param($arg) ) {
    $qs .= "&$arg=" . $value;
  }
}

$qs =~ s/^&//;

##
##  send request to radiohead.com...
##

my $h = new HTTP::Headers;
$h->referer( "http://$server/msgboard" );

my $ua = new LWP::UserAgent;
$ua->agent( 'Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)' );

my $req = new HTTP::Request( 'POST', "http://$server/cgi/msgboard/msgboard.pl", $h );
$req->content_type( 'application/x-www-form-urlencoded' );
$req->content( $qs );

my $res = $ua->request( $req );
my $post = $res->content();

##
##  format and give output...
##

$post =~ s/<\/body><\/html>//;
$post =~ s/<html><head><title>.*\n.*vlink="666666">//;
$post =~ s/href="http:\/\/$server\/msgboard\/help.html"/href="help.pl"/g;
$post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="nocache.pl?page=1"/g;
$post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="nocache.pl?post=$1|page=1"/g;
$post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="post.pl"/;
$post = edit_colors( $post );

print_text( $post );
 
footer();

###############################################################################################
###############################################################################################