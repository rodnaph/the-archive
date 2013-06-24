##################################################################
##################################################################
##
##  07.pl
##
##################################################################
##################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib/';
use lib ( LIB );

use Request;
use FileHandle qw( getline );

##################################################################

require 'output.lib';
require 'profiles.lib';

##################################################################

my $q = new Request;
my $username = $q->param('profile');

##################################################################

header($q->param("profile"), '','', 'Profiles');

if (has_profile($username)) {

  draw_profile($username);

}
else {

  open_tr();

  if ( userExists($username) ) {

    my $color = getUserColor($username);

   print_box( 'No Profile', qq{ Sorry, but <b><font color="#$color">$username</font></b> has not yet created a profile. }, 'NoUser' );

  }
  else {

    print_box( 'No User', qq{ Sorry, but there is no user called $username at radLohead.com }, 'NoUser' );

  }

}

footer();

##################################################
##
##  draw_profile(username)
##
##################################################

sub draw_profile {

  my ($vars);

  ($vars->{'username'}) = @_;

  {
    my $fh = new FileHandle(getProfilename($vars->{'username'}));
    foreach my $key ( get_file_order() ) {
      chomp( my $info = $fh->getline() );
      $vars->{ $key } = $info;
    } 

    local $/ = undef;
    $vars->{'stuff'} .= <$fh>;

    $fh->close();
  }

  ##
  ##  draw the menu and profile heading
  ##

  my $color = process_color(getUserColor($vars->{'username'}));
  my $encName = URLEncode($vars->{'username'});

  open_tr();
  print qq{ <span style="font-size:19pt;color:#$color;">$vars->{'username'}</span> };

  ##
  ##  set image
  ##

  if (valid_image($vars->{'image'})) {
    my $img = $vars->{image};
    if ( $img !~ /^http:\/\/www\.radlohead\.com\/images\/show.pl/i ) {
      $img = '/images/show.pl?url=' . URLEncode( $vars->{'image'} );
    }
    print_html("<br /><br /><img src=\"$img\" border=\"0\" alt=\"$vars->{'username'}\" />\n\n");
  } else {
    print_html("<!-- INVALID IMAGE URL - extension needs to be either jpg, png, gif or bmp : $vars->{'image'} -->\n");
  }

  ##
  ##  set website link
  ##

  if (($vars->{'website'} ne "http://") && ($vars->{'website'} =~ /^http/)) {
    print_text("<br /><br /><a target=\"_blank\" href=\"$vars->{'website'}\">$vars->{'website'}</a>\n\n");
  }

  ##
  ##  set email link
  ##

  if ($vars->{'email'}) {
    print_text("<br /><a href=\"mailto:$vars->{'email'}\">$vars->{'email'}</a>\n\n");
  }

  ##
  ##  format stuff (deprecated)
  ##

  $vars->{'stuff'} =~ s/\n/<br \/>/g;
  $vars->{'stuff'} =~ s/<br>/<br \/>/g;

  ##
  ##  print main part
  ##

  print_text("<br /><br /><b><font color=\"#FF0000\">BOARD NAME</font></b><br />");
  print_text("$vars->{'board_name'}");

  print_text("<br /><br /><b><font color=\"#FF0000\">REAL NAME</font></b><br />");
  print_text("$vars->{'real_name'}");

  print_text("<br /><br /><b><font color=\"#FF0000\">FROM</font></b><br />");
  print_text("$vars->{'from'}");

  print_text("<br /><br /><b><font color=\"#FF0000\">DATE OF BIRTH</font></b><br />");
  print_text("$vars->{'dob'}");

  print_text("<br /><br /><b><font color=\"#FF0000\">GENDER</font></b><br />");
  print_text("$vars->{'gender'}");

  print_text("<br /><br /><b><font color=\"#FF0000\">STUFF</font></b><br />");
  print_text("$vars->{'stuff'}");

  inc_views($vars->{'username'});

  ##
  ##  draw last update info
  ##

  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime) = stat(getProfilename($vars->{'username'}));
  my $last_update = gmtime($mtime);

  print_text("<p><i>(last updated $last_update)</i></p>");
  print_comments( "$vars->{'username'}'s Profile" );
  print_text( '<br />' );

}

##################################################################