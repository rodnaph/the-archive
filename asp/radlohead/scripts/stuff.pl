
use strict;

use constant PROFILES_FILE => 'd:/sites/asprad/scripts/profiles.txt';
use constant OUT_FILE => 'stuff.txt';

use FileHandle qw( getline print );

my %profiles = undef();
my $fh_pf = new FileHandle( PROFILES_FILE );
my $fh_out = new FileHandle( OUT_FILE, '>' );

while ( my $user = $fh_pf->getline() ) {

  foreach (qw( bn rn g f dob i w e )) { $fh_pf->getline(); }
  my $stuff = $fh_pf->getline();

  $fh_out->print( "##USER##\n" . $user . $stuff );

}

