#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  mailing_list.pl
##
###############################################################################################
###############################################################################################

use strict;
use CGI;
use FileHandle qw( getline print );
use File::Copy qw( copy );

use constant LIST => 'data/mailing_list.txt';
use constant TEMP => 'data/temp.tmp';

###############################################################################################

require 'lib/conc.lib';
require 'lib/stdout.lib';

###############################################################################################

my $q = new CGI;

my $heading = 'mailing list';

###############################################################################################
##
##  add to mailing list...
##
###############################################################################################

if ( $q->param('todo') eq 'add' ) {

  my $fh_lock = new FileHandle( get_default_lock_file() );
  my $email = $q->param('email');
  my $in_file = 0;

  lock_file( $fh_lock );

  {
    my $fh = new FileHandle( LIST );
    while( my $str = $fh->getline() ) {
      chomp($str);
      if ( $str =~ /^$email$/i ) { $in_file = 1; }
    }
  }

  if ( $email && !$in_file ) {
    my $fh = new FileHandle( LIST, '>>' );
    $fh->print( "$email\n" );
  }

  unlock_file( $fh_lock );

  ##
  ##  user has been added to mailing list...
  ##

  print get_header( $heading );
  print <<EOT;

<p align="center">

  email address added to list!

</p>

EOT
  print get_footer();

}

###############################################################################################
##
##  remove from mailing list...
##
###############################################################################################

elsif ( $q->param('todo') eq 'remove' ) {

  my $fh_lock = new FileHandle( get_default_lock_file() );

  lock_file( $fh_lock );

  {
    my $email = $q->param('email');
    my $fh = new FileHandle( LIST );
    my $fh_temp = new FileHandle( TEMP, '>' );

    while( my $line = $fh->getline() ) {
      chomp( $line );
      if ( $line !~ /^$email$/i ) {
        $fh_temp->print( "$line\n" );
      }
    }
    
  }

  copy( TEMP, LIST );

  unlock_file( $fh_lock );

  ##
  ##  the email has been removed from the file...
  ##

  print get_header( $heading );
  print <<EOT;

<p align="center">

  email address removed from list

</p>

EOT
  print get_footer();

}

###############################################################################################
##
##  drawing the add/remove page
##
###############################################################################################

else {

  print get_header( $heading );
  print <<EOT;

<p align="center">
  to add yourself to the mailing list ...
</p>

<center>

<form method="post" action="mailing_list.pl">

 <input type="text" name="email" size="30" maxlength="50" />

 <p>
   subscribe: <input type="radio" name="todo" value="add" checked="checked" />
   unsubscribe: <input type="radio" name="todo" value="remove" />
 </p>

 <p>
   <input type="submit" value="SUBSCRIBE/UNSUBSCRIBE" />
 </p>

</form>

</center>

EOT
  print get_footer();

}

###############################################################################################
###############################################################################################