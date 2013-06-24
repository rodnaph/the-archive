
use strict;

use constant BDAY_DIR => 'd:/sites/radlohead/files/birthdays/';
use constant OUT_FILE => 'd:/sites/asprad/bdays.txt';

use FileHandle qw( print );
use DirHandle;

for ( my $i = 1; $i < 14; $i++ ) {

  my %db;

  dbmopen %db, BDAY_DIR . $i, 0666;

  print "opened $i\n";

  foreach my $key ( keys %db ) {
    print "$key\n";
  }

  dbmclose %db;

}