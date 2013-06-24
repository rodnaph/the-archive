###############################################################################################
###############################################################################################
##
##  login.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LOGIN_LOG => BASE . 'files/msgboard_login_log.txt';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( print );
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Headers;
use Digest::MD5 qw( md5_hex );
use CGI;

###############################################################################################

require 'msgboard.lib';

###############################################################################################

my $q = new CGI;
my $server = 'www.radiohead.com';
my ( $uid, $dst ) = ();

###############################################################################################

msgboard_header();

if ( logged_in() ) {

  if ( $q->param('do_post') ) {
    post();
  }
  else {
    draw();
  }

}
else {

  ##
  ##  not logged in, draw page
  ##

  # if login failed last time
  if ( $q->param('uid') || $q->param('username') ) {
    print_box( 'Login Error', 'Sorry, but your login attempt failed.  Please try again.' );
  }

  start_box( 'Message Board Login' );

  my $text = <<EOT;

<p>
Tired of always typing in your username and password ?  Well, when you log in to the
message board here at radLohead that will be taken care of for you, allowing you to
more easily post the mindless drivvle we all love to.
<p>

<p>
It is nessecary though that your password is the same here and at radiohead.com.  We
realise not everyone will want to do this, so this feature is just an option, you can
use our standard interface if you wish.
</p>

EOT

  print_text( $text );

  start_form( 'login.pl' );
  hidden_field( 'login', 'yes' );
  text_field( 'username' );
  password_field( 'password' );
  end_form( 'LOGIN' );

  end_box();

}

footer();

###############################################################################################
##
##  post()
##
###############################################################################################

sub post {

  ##
  ##  assemble arguments...
  ##

  my @formargs = qw( followup origname origsubject origdate name pass mycolour body email subject );
  my ( $username, $password ) = split( /:#:/, get_user_data($q->param('uid')) );
  my $qs = 'name=' . URLEncode($q->param('uid')) . '&pass=' . URLEncode($password);

  foreach my $arg ( @formargs ) {
    if ( my $value = $q->param($arg) ) {
      $qs .= "&$arg=" . $value;
    }
  }

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
  $post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="login.pl?page=1&uid=$uid&dst=$dst"/g;
  $post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="login.pl?post=$1&page=1&uid=$uid&dst=$dst"/g;
  $post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl">/action="login.pl"><input type="hidden" name="do_post" value="yes" \/>/;
  $post = edit_form( $post );
  $post = edit_colors( $post );

  print_text( $post );

}

###############################################################################################
##
##  draw()
##
###############################################################################################

sub draw {

  if ( my $number = $q->param('post') ) {

    my $url = "http://$server/msgboard/messages/$number.html";
    my $post = get( $url );

    if ( $post ) {

      my $page = get_page();

      (my $fst, $post ) = split( /vlink="666666">/, $post );
      $post =~ s/href="(\d+).html"/href="login.pl?post=$1&page=$page&uid=$uid&dst=$dst"/g;
      $post =~ s/href="http:\/\/$server\/msgboard\/help.html"/href="help.pl"/g;
      $post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="login.pl?page=$page&uid=$uid&dst=$dst"/g;
      $post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="login.pl?post=$1&page=$page&uid=$uid&dst=$dst"/g;
      $post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl">/action="login.pl"><input type="hidden" name="do_post" value="yes" \/>/;
      $post =~ s/<\/body><\/html>//;
      $post = edit_form( $post );
      $post = edit_threads( $post );
      $post = edit_colors( $post );

      print $post;

    }
    else {

      print_box('Board Error', "Post $number not found at $url" );

    }

  }

  ##
  ##  else draw the main page...
  ##

  else {

    my $page = get_page();
    my $url = "http://$server/msgboard/msgboard$page.html";
    my $board = get( $url );

    if ( $board ) {

      ( my $fst, $board ) = split( /_________________________<p>/, $board );
      $board =~ s/href="msgboard(\d+).html"/href="login.pl?page=$1&uid=$uid&dst=$dst"/g;
      $board =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="login.pl?post=$1&page=$page&uid=$uid&dst=$dst"/g;
      $board =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl">/action="login.pl"><input type="hidden" name="do_post" value="yes" \/>/;
      $board =~ s/<\/body><\/html>//;
      $board = edit_form( $board );
      $board = edit_threads( $board );
      $board = edit_colors( $board );

      print $board;

    }
    else {

      print_box('Board Error', "Message Board Page $page not found at $url");

    }

  }

}

###############################################################################################
##
##  edit_form( html )
##
###############################################################################################

sub edit_form {

  my ( $html ) = @_;

  my $d_uid = URLDecode($uid);
  my $d_dst = URLDecode($dst);

  $html =~ s/USERNAME:( <br>|<br> )<input tabindex="1" type=text name="name".*size=50><br><br>/<input type="hidden" name="uid" value="$d_uid">/;
  $html =~ s/PASSWORD:( <br>|<br> )<input tabindex="2" type=password name="pass".*size=50><br><br>/<input type="hidden" name="dst" value="$d_dst">/;

  return $html;

}

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
##
##  logged_in()
##
###############################################################################################

sub logged_in {

  if ( $q->param('login') ) {
    if ( validUser( $q->param('username'), $q->param('password') ) ) {

      $uid = URLEncode( $q->param('username') );
      $dst = URLEncode( md5_hex($q->param('password')) );

      my $fh = new FileHandle( LOGIN_LOG, '>>' );
      $fh->print( $q->param('username') . "\n" );
      $fh->close();

      return 1;

    }
    else { return 0; }
  }

  my $l_uid = $q->param('uid');
  my $digest = $q->param('dst');
  my ( $name, $pass ) = split( /:#:/, get_user_data($l_uid) );

  my $check = md5_hex($pass);

  if ( userExists($l_uid) && ($digest eq $check) ) {

    $uid = URLEncode($l_uid);
    $dst = URLEncode($check);

    return 1;

  }
  else { return 0; }

}

###############################################################################################
###############################################################################################