
# auto generated

use strict;
use constant BASE => 'd:/sites/radlohead/';
use lib ( BASE . 'lib' );

require 'output.lib';

header( '','','', 'Columns' );
open_tr();

local $/ = undef();
my $fh = new FileHandle( "d:/sites/radlohead/cols/102/2/11/" . "dat2.txt" );
my $data = $fh->getline();
$fh->close();

print_box( 'Ok, first real columns', $data, ' Column' );

footer();

  