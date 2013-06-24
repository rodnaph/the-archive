###############################################################################################
###############################################################################################
##
##  show.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use CGI;
use HTTP::Headers;
use LWP::UserAgent;

###############################################################################################

require 'system.lib';

###############################################################################################

my $q = new CGI;
my $image_url = $q->param('url');

if ( my $user = $q->param('user') ) {
  $image_url = 'http://www.radlohead.com/files/images/profiles/' . URLEncode($user);
}

my ( $type ) = $image_url =~ /\.(\w+)$/;
$type = lc($type);

###############################################################################################

my $h = new HTTP::Headers;
$h->referer( $image_url );

my $ua = new LWP::UserAgent;
my $req = new HTTP::Request( 'GET', $image_url, $h );
my $res = $ua->request( $req );
my $image_data = $res->content();

$type eq 'jpg' and $type = 'jpeg';
print $q->header( -type => "image/$type", -expires => '-1d' );

binmode( STDOUT );

print $image_data;

###############################################################################################
###############################################################################################