###############################################################################################
###############################################################################################
##
##  vote.pl
##
###############################################################################################
###############################################################################################

use strict;

###############################################################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

###############################################################################################

require(BASE . "hotornot/lib/output.lib");
require(BASE . "hotornot/lib/db.lib");
require(BASE . "lib/Request.pm");

###############################################################################################

my $q = new Request;

###############################################################################################

###############################################################################################
##
##  count vote if needed
##
###############################################################################################

my ( $vote_text, $cookie );

if ( ($q->param("user") ne "") && ($q->param("vote")) ) {

  $cookie = $q->cookie( $q->param("user") );

  if ( $cookie ) {

    $vote_text = <<EOT;

<span style="font-size:14pt; font-weight:bold;">Oooops!</span><br />
Sorry, but you have already cast a vote for that picture.

EOT

  } else {

    $cookie = $q->cookie( -name => $q->param("user"),
                          -value => 1,
                          -expires => '+1y',
                          -secure => 0
                        );

    my ($name, $score) = cast_vote( $q->param("user"), $q->param("vote") );
    my $vote = $q->param("vote");

    $vote_text = <<EOT;

<span style="font-size:14pt; font-weight:bold;">Vote Cast</span><br />
You cast a vote of <b style="font-size:12pt;">$vote</b> for 
<b style="font-size:12pt;">$name</b>, who has an average score of 
<b style="font-size:12pt;">$score</b>.

EOT

  }

}

###############################################################################################
##
##  draw the next pic
##
###############################################################################################

hotornot_header( $cookie );

my $rh_pic = get_a_pic();

print_text( $vote_text );

print_text( "<p align=\"center\">" );

draw_vote_links( $rh_pic );

print_text( "<br /><span style=\"font-size:18pt;\">" . user_html( $rh_pic->{'name'} ) . "</span><br />" );
print_text( "<br /><img src=\"//www.radlohead.com/images/show.pl?url=" . URLEncode($rh_pic->{'url'}) . "\" alt=\"$rh_pic->{'name'}\" /><br />" );
print_text( "<br /><a href=\"$rh_pic->{'url'}\" target=\"_blank\"><i>$rh_pic->{'url'}</i></a><br />" );

draw_vote_links( $rh_pic );

print_text( "<br /><br />Link to this picture with the following url<br />\n" .
            "<i>http://www.radlohead.com/hotornot/vote.pl?id=$rh_pic->{'id'}</i>" );

print_text( "</p>" );

footer();

###############################################################################################
##
##  get_a_pic() : rh_pic
##
###############################################################################################

sub get_a_pic {

  if ( $q->param("id") ) {
    return get_pic_id( $q->param("id") );
  } else {
    return random_pic( $q->param("user") );
  }

}

###############################################################################################
##
##  draw_vote_links()
##
###############################################################################################

sub draw_vote_links {

  my ( $rh_pic ) = @_;

  print_html( "<br />" );

  for ( my $i=1; $i<11; $i++ ) {
    print_text( "&nbsp; <a style=\"font-size:12pt;font-weight:bold;\" href=\"vote.pl?user=$rh_pic->{'id'}|vote=$i\">$i</a> &nbsp;" );
  }

  print_html( "<br />" );

}

###############################################################################################
###############################################################################################