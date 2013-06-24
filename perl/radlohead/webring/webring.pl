###############################################################################################
###############################################################################################
##
##  webring.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant WEBRING_DB => BASE . 'files/db/webring.db';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline );
use LWP::UserAgent;
use Request;
use Dispatch;
use CGI;
use HashDatabase;

###############################################################################################

require 'logs.lib';

###############################################################################################

my $q = new CGI;
my $d = new Dispatch;

###############################################################################################

##
##  do setup...
##

if ( ! -e WEBRING_DB ) {
  my $db = new HashDatabase( WEBRING_DB );
  $db->set( 'TOP', '0' );
  $db->close();
}

##
##  dispatching...
##

$d->load(
          -prev => \&prev_site,
          -next => \&next_site,
          -random => \&random_site,
          -list => \&list_sites,
          -add => \&add_site,
          -delete => \&delete_site
        );

$d->execute( $q->param('todo') );

###############################################################################################
##
##  update_log()
##
###############################################################################################

sub update_log {

  do_log( 'webring', $q->param('todo'), $q->param('id') );

}

###############################################################################################
##
##  prev_site()
##
###############################################################################################

sub prev_site {

  update_log();

  my $id = $q->param('id');
  my $db = new HashDatabase( WEBRING_DB );
  my $index = get_prev( $id, $db );
  my ( $url ) = split( /:#:/, $db->value($index) );

  print $q->redirect( $url );

}

###############################################################################################
##
##  get_prev( id, db )
##
###############################################################################################

sub get_prev {

  my ( $id, $db ) = @_;

  if ( $id == 0 ) {
    return get_prev( $db->value('TOP'), $db );
  }
  elsif ( my $i = $db->value($id-1) ) {
    return $id -1;
  }
  else {
    return get_prev( $id-1, $db );
  }

}

###############################################################################################
##
##  next_site()
##
###############################################################################################

sub next_site {

  update_log();

  my $id = $q->param('id');
  my $db = new HashDatabase( WEBRING_DB );
  my $index = get_next( $id, $db );
  my ( $url ) = split( /:#:/, $db->value($index) );

  print $q->redirect( $url );

}

###############################################################################################
##
##  get_next( id, db )
##
###############################################################################################

sub get_next {

  my ( $id, $db ) = @_;

  if ( $id == ($db->value('TOP')-1) ) {
    return get_next( 0, $db );
  }
  elsif( my $i = $db->value($id+1) ) {
    return $id + 1;
  }
  else {
    return get_next( $id+1, $db );
  }

}

###############################################################################################
##
##  random_site()
##
###############################################################################################

sub random_site {

  update_log();

  my $db = new HashDatabase( WEBRING_DB );
  my $index = (rand() * 1000) % ($db->value('TOP') / 1);
  my ( $url ) = split( /:#:/, $db->value($index) );

  print $q->redirect( $url );

}

###############################################################################################
##
##  list_sites()
##
###############################################################################################

sub list_sites {

  webring_header();

  my $db = new HashDatabase( WEBRING_DB );
  my $ra_keys = $db->get_keys();

  start_box( 'Webring Sites' );

  my $text = <<EOT;

<p>
Below is a list of all the sites currently on our webring.  We try to ensure that they're
all live links, but some could be wrong, please tell us if you find any dead links.  Thanx.
</p>

EOT

  print_text( $text );

  foreach my $key ( @$ra_keys ) {
    if ( $key ne 'TOP' ) {
      my ( $url, $desc ) = split( /:#:/, $db->value( $key ) );
      print <<EOT;

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#ff0000"><td>
 <table width="100%" cellpadding="4" cellspacing="2" border="0"><tr bgcolor="#000000">
  <td background="/files/images/site/back.gif"><table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td>
   <a href="$url" target="_blank"><b>$url</b></a>
  </td>
  <td align="right" valign="top">
   <a href="javascript:getCode($key)">code</a>
  </td>
 </tr>
</table></td></tr>
  <tr bgcolor="#000000">
  <td background="/files/images/site/back.gif">

    <i>$desc</i>

  </td>
 </tr></table>
</td></tr></table>

<br />

EOT
    }
  }

  end_box();

  footer();

}

###############################################################################################
##
##  delete_site()
##
###############################################################################################

sub delete_site {

  my $url = $q->param('url');
  my $email = $q->param('email');
  my $db = new HashDatabase( WEBRING_DB );
  my $ra_keys = $db->get_keys();
  my $deleted = 0;
  my $text = undef();

  foreach my $key ( @$ra_keys ) {

    my ( $t_url, $t_desc, $t_email ) = split( /:#:/, $db->value($key) );
    if ( ($url =~ /$t_url/i) && ($email =~ /$t_email/i)) {
      $db->delete( $key );
      $deleted = 1;
    }

  }

  $db->close();
  webring_header();

  if ( $deleted ) {

    $text = <<EOT;
Success!  Your website has been removed from the webring.
EOT

  }
  else {

    $text = <<EOT;

<p>
Sorry, but the information you submitted did not match of the sites on the system.
</p>

EOT

  }

  print_box( 'Deleting', $text );

  footer();

}

###############################################################################################
##
##  webring_header()
##
###############################################################################################

sub webring_header {

  require 'output.lib';

  header( 'Webring' );
  top_menu({
            ITEMS => [
                       ['webring/webring.pl','main'],
                       ['webring/webring.pl?todo=list', 'list'],
                       ['webring/webring.pl?todo=random','random']
                     ],
            ALIGN => 'right'
          });
  open_tr();

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  webring_header();

  my $text = <<EOT;

<p>
Welcome to the radLohead webring.  This feature was created so that all the boardies with
their own sites could, well, make a webring.  Yes.  It's pretty simple, you can click
<a href="webring.pl?todo=random">HERE</a> to start touring the ring,
<a href="webring.pl?todo=list">here</a> to look at a list of the sites already on the
ring, or look just below if you're interested in adding your website.
</p>

EOT

  print_box( 'RadLohead Webring', $text );

  $text = <<EOT;

<p>
If you want to add your website to the the ring then just fill out the fields below
with the required information then add the code we will give you to your website.  Easy.
</p>

EOT

  start_box( 'Joining the Webring' );
  print_text( $text );

  start_form( 'webring.pl' );
  hidden_field( 'todo', 'add' );
  text_field( 'url','','',150 );
  text_field( 'email' );
  text_area( 'description', 'desc' );
  end_form( 'JOIN WEBRING' );

  end_box();

  start_box( 'Removing Yourself' );

  my $text = <<EOT;

<p>
If you wanty to remove your site from the list then just enter the url you submitted and the
contact email you gave into the form below and click DELETE.
</p>

EOT

  print_text( $text );

  start_form( 'webring.pl' );
  hidden_field( 'todo', 'delete' );
  text_field( 'url','','',150 );
  text_field( 'email' );
  end_form( 'DELETE' );

  end_box();

  footer();

}

###############################################################################################
##
##  add_site()
##
###############################################################################################

sub add_site {

  my $url = $q->param('url');
  my $desc = $q->param('desc');
  my $email = $q->param('email');

  if ( $url !~ /^http:\/\//i ) { $url = 'http://' . $url; }

  webring_header();

  if ( valid_url( $url, 10 ) && $email && $desc ) {

    my $db = new HashDatabase( WEBRING_DB );
    my $index = $db->value('TOP');

    $desc =~ s/\n/<br \/>/g;
    $db->set( 'TOP', $index + 1 );
    $db->set( $index, "$url:#:$desc:#:$email" );
    $db->close();

    my $text = <<EOT;

<p>Success!  The following site information was added to the webring...</p>

<p>
  <b>Site URL:</b> $url
  <br />
  <b>Contact Email: </b> $email
  <br />
  <b>Description: </b><blockquote> $desc </blockquote>
</p>

<p>
You can now put the following code onto your website to allow people to see you
are part of the ring, and move around the ring.  You can format it however will
best suit your site obviously, just leave the links as they are and it'll work
fine.  If you have problems using it then just get in touch with us
<a href="//www.radlohead.com/03.pl?todo=contact">here</a>.
</p>

<textarea rows="10" cols="80"><a href="http://www.radlohead.com/webring/webring.pl?todo=prev&id=$index" target="_top">prev</a> - 
<a href="http://www.radlohead.com/webring/webring.pl?todo=random" target="_top">random</a> -
<a href="http://www.radlohead.com/webring/webring.pl?todo=list" target="_top">list</a> -
<a href="http://www.radlohead.com/webring/webring.pl?todo=next&id=$index" target="_top">next</a></textarea>

EOT

    print_box( 'Site Added', $text );

  }
  else {

    my $text = <<EOT;

<p>
Sorry, but there was something wrong with your submission, this could be for one or
more of the following reasons...
</p>

<ul>
 <li>You missed out a field</li>
 <li>You submitted an invalid url</li>
</ul>

<p>
If you have filled out all the fields then the error must be that we were not able to validate
the url you submitted.  This may be because it is wrong, or just because your server didn't
respond quick enough.  If the latter is the case then try again until we are able to verify
the validity of the url. If you have any problems then please contact us
<a href="//www.radlohead.com/03.pl?todo=contact">here</a>
</p>

EOT

    print_box( 'Submission Error', $text );

  }

  footer();

}

###############################################################################################
##
##  valid_url( url, timeout )
##
###############################################################################################

sub valid_url {

  my ( $url, $timeout ) = @_;

  my $ua = new LWP::UserAgent();
  $ua->timeout( $timeout );
  my $req = new HTTP::Request( 'GET', $url );
  my $res = $ua->request( $req );

  return $res->is_success();

}

###############################################################################################
###############################################################################################