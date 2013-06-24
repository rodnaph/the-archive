
use strict;

use constant PROFILES_DIR => 'd:/sites/asprad/scripts/profiles/';
use constant OUT_FILE => 'd:/sites/asprad/scripts/profiles.txt';

use FileHandle qw( print getline );
use DirHandle;

my %users = undef();
my $fh_out = new FileHandle( OUT_FILE, '>' );
my $dh = new DirHandle( PROFILES_DIR );

while ( my $file = $dh->read() ) {

  if ( $file =~ /\.nfo$/ ) {

    my $fh = new FileHandle( PROFILES_DIR . $file );
    print "$file\n";

    while ( my $filename = $fh->getline() ) {

      my ( $name ) = $filename =~ /^(.*)\.nfo$/;

      $name = decode( $name );

      my $dontadd = ( $users{uc($name)} ) ? 1 : 0;

      $users{uc($name)} = 1;
      $fh_out->print( "$name\n" ) unless $dontadd;

      foreach my $field (qw( bn rn g f db e i w s )) {
        my $line = $fh->getline();
        $fh_out->print( $line ) unless $dontadd;
      }

    }

  }

}

$fh_out->close();
$dh->close();

print "\nDone.";



sub decode {

  my ( $text ) = @_;

  $text =~ tr/+/ /;
  $text =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack("C",hex($1))/eg;

  return $text;

}