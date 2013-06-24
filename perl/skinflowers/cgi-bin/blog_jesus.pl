#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  blog_jesus.pl
##
###############################################################################################
###############################################################################################

##
##  gary, here's the script, hope it's ok.  u said to allow the file created to be
##  4mb ?  well... i thought that was kinda crazily big... but u can set it to whetever
##  you want by altering the constant below.  when the file reaches the maximum size
##  it wipes it and starts again.  that ok ?
##
##  i didn't know what to name the script,  rich came up with blog_jesus, heh heh.
##  but u can change it to whatever u want, it won't effect anything.
##
##  oh and the date bit, u didn't want to pass that into the script did ya ?  cause surely
##  it's just way simpler for the script to determine the time ?  tell me if i did bad.
##

use strict;
use CGI;
use FileHandle qw( getline print );

use constant BLOG_FILE => '../www/mcjesus/blogcontents.txt';
use constant MAX_FILE_SIZE => 900000; # bytes

###############################################################################################

my $q = new CGI;
my $old_contents;

my $postedby = $q->param('postedby');
my $date = gmtime( time );
my $message = $q->param('message');

###############################################################################################
##
##  insert new post into file at top...
##
###############################################################################################

if ( !limit_reached() && (-e BLOG_FILE) ) {

  local $/ = undef;
  my $fh = new FileHandle( BLOG_FILE );
  $old_contents = $fh->getline();

}

my $fh = new FileHandle( BLOG_FILE, '>' );

##
##  gary, this is what gets written to the file...
##  if ya don't know, the words starting with $ are the variables
##  from the form, so ya can do whatever ya want with them. the layout
##  is unimportant regarding the functionality of the script, so feel free
##  to change it however u need to.
##

print $fh <<EOT;

[ $postedby ] on [ $date ] <br /><br />

$message<br /><br />

EOT
$fh->print( $old_contents );

###############################################################################################
##
##  script output...
##
##  the script obviously needs to give some kind of output, this it it.  edit it
##  however u want, just leave the first 2 lines in cause otherwise it won't
##  work (the Content-type... bit).  and make sure there is a blank line after
##  that bit like i have left.
##
###############################################################################################

print $q->redirect( '/mcjesus/index.shtml' );

###############################################################################################
##
##  limit_reached();
##
###############################################################################################

sub limit_reached {

  my ( @info ) = stat( BLOG_FILE );

  return ($info[7] gt MAX_FILE_SIZE) ? 1 : 0;

}

###############################################################################################
###############################################################################################