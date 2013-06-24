##################################################################
##################################################################
##
##  01.pl
##
##################################################################
##################################################################

use strict;

use constant BASE => 'd:/sites/radlohead/Archive/2002/';
#use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib/';
use lib ( LIB );

use FileHandle qw( getline );
use LWP::Simple;

##################################################################

require 'output.lib';

##################################################################

#my $posts = get( 'http://www.radiohead.com/msgboard/data.txt' );

##################################################################

header();
open_tr();

print_section( 'Welcome' );

print_section( 'NatalieSalt' );

print_section( 'SiteNews' );

footer(1);

##################################################################