###############################################################################################
###############################################################################################
##
##  list.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'd:/sites/radlohead/';
#use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline );
use Request;

###############################################################################################

require 'profiles.lib';
require 'output.lib';

###############################################################################################

my $q = new Request;

###############################################################################################

my $from = $q->param('from');
my $to = $q->param('to');
my $actual_to = $to;

!$to and $to = $from;
$to eq 'REST' and $to = "Z";
$to lt $from and (( $to, $from ) = ( $from, $to ));

##
##  draw header and menu
##

header( 'Profiles', get_menu() );

{
  my ( $ra_items, $to_url, $from_url );

  $to_url = "|to=$to" unless (ord($from) < ord('B'));
  $from_url = '|to='.uc(chr(ord($to)+1)) unless (ord($to) > ord('Y'));

  if (ord($from) > ord('A')) { push(@$ra_items,['list.pl?from='.uc(chr(ord($from)-1)).$to_url,'less']); }

  for (my $i=ord($from); $i < (ord($to)+1); $i++) {
    my $l = lc(chr($i));
    push( @$ra_items, ['#'.uc($l),$l] );
  }
  if ($actual_to eq 'REST') { push( @$ra_items, ['#REST', 'rest'] ); }
  elsif (ord($to) < ord('Z')) { push( @$ra_items, ["list.pl?from=$from".$from_url,'more']); }

  top_menu( $ra_items );

}

##
##  page heading
##

my $draw_to;
if ($actual_to) {
  $draw_to = " - $actual_to";
}

start_box( "Profiles $from $draw_to");
print <<EOT;

(<i>italics</i> mean there is no profile,
<br />
<img src="../files/images/site/has_image.gif"
 width="12" height="12" alt="profile has an image" />
means there is an image.)");

EOT

##
##  load and draw users
##

my $profiles_drawn_count = 0;

for (my $i=ord($from); $i < (ord($to)+1); $i++) {

  my @users;

  my $fh = new FileHandle(getUserFile(chr($i)));
  while( my $user = $fh->getline() ) {
    chomp($user);
    if ($user) { push( @users, $user ); }
  }
  $fh->close();

  draw_shortcut( chr($i) );
  draw_users( \@users, $from, $to, \$profiles_drawn_count );

}

##
##  PROFILES THAT START
##  WITH NUMBERS
##

if (($actual_to eq 'REST') or ($from eq 'REST')) {
  draw_shortcut('REST');
  my $fh = new FileHandle(getUserFile('0'));
  while( my $profile = $fh->getline() ) {
    print '<br />';
    print_user_data($profile);
    $profiles_drawn_count++;
  }
  $fh->close();
}

print "<p>(<b>$profiles_drawn_count</b> profiles drawn)</p>";
end_box();

footer();

###############################################################################################
##
##  draw_users( ra_users, from, to, rs_profiles_drawn_count)
##
###############################################################################################

sub draw_users {

  my ( $ra_users, $from, $to, $rs_profiles_drawn_count ) = @_;

  foreach my $user ( sort(@$ra_users) ) {

    print '<br />';
    print_user_data( $user );

    $$rs_profiles_drawn_count++;

  }

}

###############################################################################################
##
##  draw_shortcut( link )
##
###############################################################################################

sub draw_shortcut {

  my ( $link ) = @_;

  print '<br /><br /><a name="' . $link . '"></a>';

}

###############################################################################################
###############################################################################################