###############################################################################################
###############################################################################################
##
##  admin.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant OWNER => 'natalie salt';
use constant DATA_FILE => BASE . 'admin/NatalieSalt/text';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline print );
use CGI;

###############################################################################################

require 'output.lib';
require 'columns.lib';

###############################################################################################

my $q = new CGI;

###############################################################################################
##
##  update if needed...
##
###############################################################################################

header( 'Admin - ' . OWNER );
open_tr();

if ( $q->param('update') ) {

  my $title = $q->param('title');
  my $maintext = $q->param('maintext');
  my $fh = new FileHandle( DATA_FILE, '>' );

  $maintext =~ s/\n/<br \/>/g;
  $fh->print( "$title\n$maintext" );

  add_column( $title, OWNER, $maintext, OWNER . 's Section' );

}

###############################################################################################
##
##  draw page...
##
###############################################################################################

if ( validUser( OWNER, $q->param('password') ) ) {

  my $fh = new FileHandle( DATA_FILE );
  my $title = $fh->getline();

  local $/ = undef();

  my $maintext = $fh->getline();

  $maintext =~ s/<br \/>/\n/g;

  start_box( OWNER . ' Logged In!', 'SectionAdmin' );
  print qq{ To change your section just edit the text in the boxes and click };
  print_submit('CHAnGE');

  start_form( 'admin.pl' );
  hidden_field( 'update', 'yes' );
  hidden_field( 'password', $q->param('password') );
  text_field( 'Title', 'title', 80,'', $title );
  text_area( 'Main Text', 'maintext',70,30, $maintext );
  end_form( 'CHANGE' );

  end_box();

}

###############################################################################################
##
##  else login page...
##
###############################################################################################

else {

  start_box( 'Login' );
  print OWNER . ', to login just enter your password below.';

  start_form( 'admin.pl' );
  password_field( 'password' );
  end_form( 'LOGIN' );

  end_box();

}

footer();

###############################################################################################
###############################################################################################