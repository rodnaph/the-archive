
use strict;

use constant PROFILES_FILE => 'd:/sites/asprad/scripts/profiles.txt';
use constant USER_FILE => 'd:/sites/asprad/scripts/users.txt';
use constant OUT_FILE => 'out.txt';

use FileHandle qw( getline print );

my %profiles = undef();
my $fh_pf = new FileHandle( PROFILES_FILE );

while ( my $user = $fh_pf->getline() ) {

  chomp( $user );
  $profiles{uc($user)} = 1;
  foreach (qw( bn rn g f dob i w e s )) { $fh_pf->getline(); }

}

my $fh_u = new FileHandle( USER_FILE );
my $fh = new FileHandle( OUT_FILE, '>' );

while( my $user = $fh_u->getline() ) {

  chomp( $user );
  my $pass = $fh_u->getline();
  chomp( $pass );

  my $pf = ( $profiles{uc($user)} ) ? 1 : 0;

  $fh->print( "$user\n$pass\n$pf\n" );

}