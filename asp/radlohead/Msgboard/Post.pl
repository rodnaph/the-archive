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

my @formargs = qw( followup origname origsubject origdate name pass mycolour body email subject );
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

$post =~ s/href="http:\/\/$server\/msgboard\/help.html"/href="help.pl"/g;
$post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="NoCache.pl?page=1"/g;
$post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="NoCache.pl?post=$1&page=1"/g;
$post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="Post.pl"/;

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