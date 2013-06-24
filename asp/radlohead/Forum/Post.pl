###############################################################################################
###############################################################################################
##
##  post.pl
##
###############################################################################################
###############################################################################################

use strict;

use LWP::UserAgent;
use HTTP::Headers;
use CGI;

###############################################################################################

my $q = new CGI();
my $server = 'www.radiohead.com';

###############################################################################################

print $q->header( -type => 'text/html' );

##
##  assemble arguments...
##

my @formargs = qw( Type Name Password MsgColour Body Email Subject ID );
my $qs = '';

foreach my $arg ( @formargs ) {
  if ( my $value = $q->param($arg) ) {
    $qs .= "&$arg=" . encode($value);
  }
}

$qs =~ s/^&//;

##
##  send request to radiohead.com...
##

my $h = new HTTP::Headers;
$h->referer( "http://$server/Forum" );

my $ua = new LWP::UserAgent;
$ua->agent( 'Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)' );

my $req = new HTTP::Request( 'POST', "http://$server/Forum/SubmitMessage.html", $h );
$req->content_type( 'application/x-www-form-urlencoded' );
$req->content( $qs );

my $res = $ua->request( $req );
my $post = $res->content();

##
##  format and give output...
##

$post =~ s/http:\/\/$server\/Forum\/dim.html\?ID=(\d+)/NoCache.pl?post=$1/;
$post =~ s/http:\/\/$server\/Forum/NoCache.pl/;

# do html bit...
$post =~ s/\{link\}(.*)\{\/link\}/<a href="$1">$1<\/a>/gi;
$post =~ s/\{img\}(.*)\{\/img\}/<img src="$1" \/>/gi;

print $post;

###############################################################################################
##
##  encode( text ) : text
##
###############################################################################################

sub encode {

  my ( $text ) = @_;

  $text =~ s/([^a-z0-9_.~-])/ sprintf "%%%02X", ord($1)/eig;

  return $text;

}

###############################################################################################
###############################################################################################