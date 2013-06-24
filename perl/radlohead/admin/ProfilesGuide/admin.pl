###############################################################################################
###############################################################################################
##
##  ProfilesGuide admin section
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant RUN_BY => 'zorburt';
use constant TOP_TEXT => BASE . 'admin/ProfilesGuide/toptext.txt';
use constant BOTTOM_TEXT => BASE . 'admin/ProfilesGuide/bottomtext.txt';
use constant PROFILES => BASE . 'admin/ProfilesGuide/profiles.txt';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use Request;
use FileHandle qw( print getline );
use Dispatch;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request;
my $d = new Dispatch;

###############################################################################################

header( 'ProfilesGuide' );
open_tr();

##
##  dispatch updating...
##

$d->load(
          -topText => sub { update_text( 'topText' ,TOP_TEXT ); },
          -bottomText => sub { update_text( 'bottomText' , BOTTOM_TEXT ); },
          -addProfile => \&add_profile,
          -removeProfile => \&remove_profile,
          -default => sub {}
        );

$d->execute( $q->param('update') );

##
##  drawing the page...
##

if ( validUser( RUN_BY, $q->param('password') ) ) {
  draw_page();
}
else {
  if ( $q->param('password') ) {
    print_box( 'Login Fail', 'Sorry, but you did not enter the correct password.' );
  }
  login();
}

footer();

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  my ( $topText, $bottomText ) = ();

  {
    local $/ = undef;

    my $fh = new FileHandle( TOP_TEXT );

    $topText = $fh->getline();
    $fh->close();
    $fh->open( BOTTOM_TEXT );
    $bottomText = $fh->getline();

  }

  $topText =~ s/<br \/>/\n/g;
  $bottomText =~ s/<br \/>/\n/g;

  start_box( 'ProfilesGuideAdmin for ' . user_html(RUN_BY) );

  start_form( 'admin.pl' );
  hidden_field( 'password', $q->param('password') );
  end_form( 'REFRESH_PAGE' );

  print qq{

<p><hr /></p>

<p>
This is the top message that appears above your list of profiles.  Don't worry about line
breaks, they'll be inserted for you.
</p>

  };

  start_form( 'admin.pl' );
  hidden_field( 'password', $q->param('password') );
  hidden_field( 'update', 'topText' );
  text_area( 'Text', 'topText', '','', $topText );
  end_form( 'CHANGE TOP TEXT' );

  print qq{

<p><hr /></p>

<h2>Remove Profile</h2>

<p>This is where you can delete profiles that you have listed.</p>

  };

  start_form( 'admin.pl' );
  hidden_field( 'password', $q->param('password') );
  hidden_field( 'update', 'removeProfile' );

  ##
  ##  add profiles
  ##

  my $fh = new FileHandle( PROFILES );
  while( my $profile = $fh->getline() ) {
    chomp( $profile );
    my ( $name, $comment ) = split( /:#:/, $profile );
    print qq{

<br />
<input type="checkbox" name="removeProfile" value="$name"> - <b>$name</b> (<i>$comment</i>)

    };
  }
  $fh->close();

  end_form( 'REMOVE SELECTED PROFILES' );

  print qq{

<p><hr /></p>

<h2>Add Profile</h2>

<p>
This is where you can add profiles to your list (make sure you get them exactly
right or they won't be added)
</p>

  };

  start_form( 'admin.pl' );
  hidden_field( 'password', $q->param('password') );
  hidden_field( 'update', 'addProfile' );
  text_field( 'name', 'addProfile' );
  text_area( 'comments', 'addProfileText', 43,5 );
  end_form( 'ADD PROFILE' );

  print qq{

<p><hr /></p>

<p>This is the bottom message that appears below your list of profiles.
</p>

  };

  start_form( 'admin.pl' );
  hidden_field( 'password', $q->param('password') );
  hidden_field( 'update', 'bottomText' );
  text_area( '', 'bottomText', 60,8, $bottomText );
  end_form( 'CHANGE BOTTOM TEXT' );

  end_box();

}

###############################################################################################
##
##  login()
##
###############################################################################################

sub login {

  start_box( 'Login' );

  print qq{
<p>
To login just enter the password of whoever is in charge of this section
and click <b>LOGIN</b>
</p>

  };

  start_form( 'admin.pl' );
  password_field( 'password' );
  end_form( 'LOGIN' );

  end_box();

}

###############################################################################################
##
##  remove_profile()
##
###############################################################################################

sub remove_profile {

  my ( @profiles ) = $q->param('removeProfile');
  my $deleted = 0;

  foreach my $profile ( @profiles ) {

    local @ARGV = PROFILES;
    local $^I = '.bk';

    while( <> ) {
      if ( !/^$profile:#:/ ) { print; }
      else { $deleted = 1; }
    }

  }

  if ( $deleted ) {
    print_box( 'Update Made', 'The user ' . $q->param('removeProfile') . ' was deleted.' );
  }
  else {
    print_box( 'Error', 'The user ' . $q->param('removeProfile') . ' was not deleted, if the problem persists, contact admin.' );
  }

}

###############################################################################################
##
##  add_profile()
##
###############################################################################################

sub add_profile {

  if (userExists($q->param('addProfile'))) {

    my $profileText = $q->param('addProfileText');
    my $fh = new FileHandle( PROFILES, '>>' );

    $profileText =~ s/\n/<br \/>/g;
    $fh->print( $q->param('addProfile') . ":#:$profileText\n" );
    $fh->close();

    print_box( 'Update Made', 'User ' . $q->param('addProfile') . ' was added.' );

  }

  print_box( 'Error', 'User ' . $q->param('addProfile') . ' is not a valid radLohead user.' );

}

###############################################################################################
##
##  update_text( type, file )
##
###############################################################################################

sub update_text {

  my ( $type, $file ) = @_;

  my $text = $q->param( $type );
  my $fh = new FileHandle( $file, '>' );

  $text =~ s/\n/<br \/>/g;
  $fh->print( $text );
  $fh->close();

  print_box( 'Update Made', 'The ' . $type . ' was successfully updated.' );

}

###############################################################################################
###############################################################################################