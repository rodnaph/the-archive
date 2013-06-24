
use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant FILE => BASE . 'alt/Local/ip.txt';

use CGI;
use FileHandle qw( getline );

my $q = new CGI();
my $fh = new FileHandle( FILE );
my $ip = $fh->getline();

print $q->redirect( 'http://' . $ip . '/Home' );
