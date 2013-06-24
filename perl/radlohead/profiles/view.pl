###############################################################################################
###############################################################################################
##
##  07.pl
##
###############################################################################################
###############################################################################################

use strict;
use FileHandle qw( getline );

#use constant BASE => "f:/newmind/radiohead/";
use constant BASE => "d:/sites/radlohead/";
use constant LIB => BASE . "lib/";
use lib ( LIB );

use Request;

###############################################################################################

require 'output.lib';
require 'profiles.lib';

###############################################################################################

my $q = new Request;
my $username = $q->param('profile');

###############################################################################################

header( $username, get_menu() );

if (has_profile($username)) {

  ##
  ##  DRAW THE
  ##  PROFILE
  ##

  draw_profile($username);

}
else {

  ##
  ##  THE USER HAS
  ##  NOT CREATED A
  ##  PROFILE
  ##

  my $color = getUserColor($username);

  print( 'No Profile', qq{

<p>
Sorry, but <b><font color=\"#$color\">$username</font></b> has not yet created a profile.
</p>

  });

}

footer();

###############################################################################################
##
##  draw_profile(username)
##
###############################################################################################

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

  print qq{ <font face="arial,helvetica,verdana" size="+3" color="#$color">$vars->{'username'}</font> };

  ##
  ##  set image
  ##

  if (valid_image($vars->{'image'})) {
    my $img = $vars->{image};
    if ( $img !~ /^http:\/\/www\.radlohead\.com\/images\/show.pl/i ) {
      $img = '/images/show.pl?url=' . URLEncode( $vars->{'image'} );
    }
    print qq{ <br /><br /><img src="$img" border="0" alt="$vars->{'username'}" />\n\n };
  } else {
    print qq{ <!-- INVALID IMAGE URL - extension needs to be either jpg, png, gif or bmp : $vars->{'image'} -->\n };
  }

  ##
  ##  set website link
  ##

  if (($vars->{'website'} ne "http://") && ($vars->{'website'} =~ /^http/)) {
    print qq{ <br /><br /><a target="_blank" href="$vars->{'website'}">$vars->{'website'}</a>\n\n };
  }

  ##
  ##  set email link
  ##

  if ($vars->{'email'}) {
    print qq{ <br /><a href="mailto:$vars->{'email'}">$vars->{'email'}</a> };
  }

  ##
  ##  format stuff (deprecated)
  ##

  $vars->{'stuff'} =~ s/\n/<br \/>/g;
  $vars->{'stuff'} =~ s/<br>/<br \/>/g;

  ##
  ##  print main part
  ##

  print qq{

<br /><br />
<b>BOARD NAME:</b>
$vars->{'board_name'}

<br />

<b>REAL NAME:</b>
$vars->{'real_name'}

<br />

<b>FROM:</b>
$vars->{'from'}

<br />

<b>DATE OF BIRTH:</b>
$vars->{'dob'}

<br />

<b>GENDER:</b>
$vars->{'gender'}

<br />

<b>STUFF:</b><br />
<blockquote>
$vars->{'stuff'}
</blockquote>

  };

  inc_views($vars->{'username'});

  ##
  ##  draw last update info
  ##

  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime) = stat(getProfilename($vars->{'username'}));
  my $last_update = gmtime($mtime);

  print "<p><i>(last updated $last_update)</i></p>";
  print_comments( "$vars->{'username'}'s Profile" );
  print '<br />';

}

###############################################################################################
###############################################################################################