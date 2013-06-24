###############################################################################################
###############################################################################################
##
##  create.pl
##
###############################################################################################
###############################################################################################

use strict;
use FileHandle qw( print );

###############################################################################################

use constant BASE => 'e:/sites/radlohead/';
use constant LIB => BASE . 'journals/lib';
use lib ( LIB );

###############################################################################################

require 'output.lib';
require 'main.lib';

###############################################################################################

my $q = new Request();
my $dispatch = new Dispatch();
$dispatch->load( -create => 'create_journal' );

###############################################################################################

j_header();

$dispatch->execute( $q->param('todo') );

footer();

###############################################################################################
##
##  create_journal()
##
###############################################################################################

sub create_journal {

  if ( validUser($q->param('username'),$q->param('password')) ) {

    if ( has_journal( $q->param('username') ) ) {

      ##
      ##  user already has a journal...
      ##

      start_box( 'Journal Already Exists' );
      print_text( 'Sorry, but a journal for that username has already been created.  If you ' .
                  'want to clear your journal and start again then you must first delete it ' . 
                  'using the <b>delete</b> button above, then create it again.' );
      end_box();

    } else {

      ##
      ##  create journal...
      ##

      dbmopen my %db, get_journal_file( $q->param('username') ), get_journal_perms();
      undef %db;
      $db{created} = time;
      dbmclose %db;

      my $fh = new FileHandle( get_journals_file(), '>>' );
      $fh->print( $q->param('username') . "\n" );
      $fh->close();

      start_box( 'Journal Created' );
      print_text( 'Congratulations, you have just created your very own journal here at ' .
                  'radLohead.  To add new entries to your journal just click on the <b>update</b> ' .
                  'link in the menu above.' );
      end_box();

    }

  } else {

    ##
    ##  invalid user...
    ##

    start_box( 'Invalid User' );
    print_text( 'Sorry, but you entered an invalid username/password combination.  Please ' .
                'go back and try again.' );
    end_box();

  }

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  start_box( 'Creating a Journal' );
  print_text( 'If you have a username registered here at radLohead then you can create ' .
              'a journal for it, an online diary really for us who like to indulge in ' .
              'eachothers lives.' );

  start_form( 'create.pl' );
  hidden_field( 'todo', 'create' );
  text_field( 'username' );
  password_field( 'password' );
  end_form( 'CREATE' );
  end_box();

}

###############################################################################################
###############################################################################################