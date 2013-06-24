#!/usr/bin/perl

use strict;
use warnings;

use constant AUDIO_DIR => '../www/audio/';

use CGI::Carp qw( fatalsToBrowser );
use Net::FTP;
use DirHandle;

# create objects
my $ftp = Net::FTP->new( '209.51.158.90' );
my $dh = new DirHandle( AUDIO_DIR );

# login
$ftp->login( 'skinorg', 'bling52' );

# loop through directory
while ( my $file = $dh->read() ) {

  if ( $file !~ /^(\.|\.\.)$/ ) {

    $ftp->put( AUDIO_DIR . $file, '/home/skinorg/public_html/audio/' . $file );

  }

}

# send http headers
print "Content-type: text/html\n\n";

# give output
print <<EOT;

Done.

EOT

# end.