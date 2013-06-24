#############################################################
#############################################################
##
##  12.pl
##
#############################################################
#############################################################

use strict;

use constant BASE => "f:/newmind/radiohead/";
use constant LIB => BASE . 'lib';
use lib ( LIB );

#############################################################

require(BASE . "lib/system.lib");
require(BASE . "lib/output.lib");
require(BASE . "lib/profiles.lib");
require(BASE . "lib/Request.pm");

#############################################################

my $q = new Request;

#############################################################
#############################################################

header( 'Stats', '','', 'Profiles' );
open_tr();

if (validUser($q->param("username"),$q->param("password"))) {

  draw_stats();

} else {

  start_box( 'Stats Login', 'Stats' );

  start_form("12.pl");
  text_field("username");
  password_field("password");
  end_form("LOGIN");

  end_box();

}

footer();

#############################################################
##
##  draw_stats()
##
#############################################################

sub draw_stats {

  start_box( "stats for <a href=\"07.pl?profile=" . URLEncode($q->param("username")) . "\" class=\"profile_link\"><font color=\"" . getUserColor($q->param("username")) . "\">" . $q->param("username") . "</font></a>", 'Stats' );

  ##
  ##  draw access info
  ##

  print_text("your profile has recieved <b>" . get_views($q->param("username")) . "</b> hits since 1st July 2001");

  ##
  ##  draw file info
  ##

  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat(getProfilename($q->param("username")));

  print_text("<br /><br /><font size=\"+1\">profile info</font>");
  print_text("<br />last updated: <b>" . gmtime($mtime) . "</b>");
  print_text("<br />last accessed: <b>" . gmtime($atime) . "</b>");
  print_text("<br />total size: <b>$size</b> bytes");

  ##
  ##  draw refresh button
  ##

  start_form("12.pl");
  hidden_field("username",$q->param("username"));
  hidden_field("password",$q->param("password"));
  end_form("REFRESH PAGE");

  end_box();

}

#############################################################