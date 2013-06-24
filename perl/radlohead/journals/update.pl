###############################################################################################
###############################################################################################
##
##  update.pl
##
###############################################################################################
###############################################################################################

use strict;

###############################################################################################

use constant BASE => 'e:/sites/radlohead/';
use constant LIB => BASE . 'journals/lib';
use lib ( LIB );

###############################################################################################

require 'output.lib';
require 'main.lib';

###############################################################################################

my $q = new Request();

###############################################################################################

j_header();

if ( $q->param('todo') eq 'add_entry' ) {

  my $id = time;

  dbmopen my %db, get_journal_file( $q->param('username') ), get_journal_perms();
  $db{$id} = $q->param('entry');
  dbmclose %db;

  print_box( 'Entry Added', 'You have successfully added a new entry to your journal' );

} elsif ( $q->param('todo') eq 'top_text' ) {
  
  dbmopen my %db, get_journal_file( $q->param('username') ), get_journal_perms();
  $db{text} = $q->param('top_text');
  dbmclose %db;

  print_box( 'Top Text Changed', 'Your top text has been successfully edited' );

}

if ( validUser( $q->param('username'),$q->param('password') ) && has_journal( $q->param('username') ) ) {

  ##
  ##  get info...
  ##

  dbmopen my %db, get_journal_file( $q->param('username') ), get_journal_perms();
  my $top_text = $db{text};
  dbmclose %db;

  ##
  ##  draw forms...
  ##

  start_box( 'New Entry' );
  print_text( 'To add a new entry yo your journal, just type it in below and click ' );
  print_submit( 'ADD ENTRY' );

  start_form( 'update.pl' );
  hidden_field( 'todo', 'add_entry' );
  hidden_field( 'username', $q->param('username') );
  hidden_field( 'password', $q->param('password') );
  text_area( ' ', 'entry' );
  end_form( 'ADD ENTRY' );
  end_box();

  start_box( 'Top Text' );
  print_text( 'To change the text that appears at the top of your journal, just edit the text in the ' .
              'area below and click ' );
  print_submit( 'CHANGE' );

  start_form( 'update.pl' );
  hidden_field( 'todo', 'top_text' );
  hidden_field( 'username', $q->param('username') );
  hidden_field( 'password', $q->param('password') );
  text_area( ' ', 'top_text', '', '', $top_text );
  end_form( 'CHANGE' );
  end_box();

} else {

  start_box( 'Journal Login' );
  print_text( 'To login and add entries to your journal just enter your username and ' .
              'password, then click ' );
  print_submit( 'LOGIN' );

  start_form( 'update.pl' );
  text_field( 'username' );
  password_field( 'password' );
  end_form( 'LOGIN' );
  end_box();

}

footer();

###############################################################################################
###############################################################################################