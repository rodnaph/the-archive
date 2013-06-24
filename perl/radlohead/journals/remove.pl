###############################################################################################
###############################################################################################
##
##  remove.pl
##
###############################################################################################
###############################################################################################

use strict;
use FileHandle qw( getline print );

###############################################################################################

use constant BASE => 'e:/sites/radlohead/';
use constant LIB => BASE . 'journals/lib';
use lib ( LIB );

###############################################################################################

require 'output.lib';
require 'main.lib';

###############################################################################################

my $q = new Request();
my $username = $q->param('username');

###############################################################################################

j_header();

if ( $q->param('todo') eq 'remove' ) {

  if ( validUser( $username, $q->param('password') ) ) {

    if ( has_journal( $username ) ) {

      ##
      ##  remove journal...
      ##

      my $old = get_journals_file();
      my $temp = get_temp('remove_journal');

      {

        my $fh = new FileHandle( $old );
        my $fh_temp = new FileHandle( $temp, '>' );

        while ( my $journal = $fh->getline() ) {
          if ( $journal !~ /^$username/i ) {
            $fh_temp->print( $journal );
          }
        }

      }

      copy_file( $temp, $old );

      ##
      ##  output...
      ##

      start_box( 'Journal Removed' );
      print_text( 'Success, you have removed your journal from our system.  If you want to ' .
                  'create another then you can, just click the <b>create</b> button above.' );
      end_box();

    } else {

      ##
      ##  user doesn't HAVE a journal...
      ##

      start_box( 'No Journal' );
      print_text( 'Sorry, but there is no journal for that username on our system.' );
      end_box();

    }

  } else {

    ##
    ##  invalid user...
    ##

    start_box( 'Input Error' );
    print_text( '<p>Sorry, but you did not enter a valid username/password combination.</p>' );
    end_box();

  }

} else {

  start_box( 'Removing A Journal' );
  print_text( 'To remove your journal, just enter your username and password into the form ' .
              'below and click ' );
  print_submit( 'REMOVE' );

  start_form( 'remove.pl' );
  hidden_field( 'todo', 'remove' );
  text_field( 'username' );
  password_field( 'password' );
  end_form( 'REMOVE' );
  end_box();

}

footer();

###############################################################################################
###############################################################################################