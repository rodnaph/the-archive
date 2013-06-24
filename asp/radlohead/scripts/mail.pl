
use strict;

use constant MAIL_DIR => 'd:/sites/radlohead/files/mailbox/';
use constant OUT_FILE => 'd:/sites/asprad/mail.txt';

use FileHandle qw( print );
use DirHandle;

my $dh = new DirHandle( MAIL_DIR );
my $fh_out = new FileHandle( OUT_FILE, '>' );

while ( my $file = $dh->read() ) {

  if ( $file =~ /mbx$/ ) {

    my $fh = new FileHandle( MAIL_DIR . $file );

    while ( my $line = $fh->getline() ) {

      chomp( $line );

      my ( $to, $from, $subject, $message ) = split( /:#:/, $line );

      $fh_out->print( $to . "\n" .
                      $from . "\n" .
                      $subject . "\n" .
                      $message . "\n" );

    }

  }

}