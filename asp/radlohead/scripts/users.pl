
use strict;

use constant USERS_DIR => 'd:/sites/asprad/scripts/users/';
use constant OUT_FILE => 'd:/sites/asprad/scripts/users.txt';

use FileHandle qw( getline print );
use DirHandle;

my $fh_out = new FileHandle( OUT_FILE, '>' );
my $dh = new DirHandle( USERS_DIR );

while ( my $file = $dh->read() ) {

  if ( $file =~ /\.usr$/ ) {

    my $fh = new FileHandle( USERS_DIR . $file );

    while ( my $userdata = $fh->getline() ) {

      my ( $username, $password ) = split( /:#:/, $userdata );
      $fh_out->print( "$username\n$password\n" );

    }

  }

}

$fh_out->close();
$dh->close();

print "\nDone.";