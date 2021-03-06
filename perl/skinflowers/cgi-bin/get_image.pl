###############################################################################################
###############################################################################################
##
##  get_image.pl
##
###############################################################################################
###############################################################################################

use strict;

use CGI;
use FileHandle qw( print );

use constant BASE => '../';
use constant LOG => 'data/log.txt';
use constant BUFFER_SIZE => 4_096;
use constant IMAGE_DIR => BASE . 'www/images/';

###############################################################################################

my $q = new CGI;

###############################################################################################
##
##  do logging...
##
###############################################################################################

my $fh = new FileHandle( LOG, '>>' );
my $date = gmtime( time() );
my $ref = $q->param('ref');
my $line = "DATE:#:$date:##:REFERRER:#:$ref";
foreach my $key ( keys %ENV ) {
  $line .= ":##:$key:#:$ENV{$key}";
}
$fh->print( "$line\n" );
$fh->close();

###############################################################################################
##
##  output image data...
##
###############################################################################################

my $image = $q->param('image');
my $buffer = '';
my ( $type ) = $image =~ /\.(\w+)$/;
$type eq "jpg" and $type = 'jpeg';

print $q->header( -type => "image/$type", -expires => '-1d' );

local *IMAGE;
open IMAGE, IMAGE_DIR . $image or die "Cannot find file $image: $!";
while( read( IMAGE, $buffer, BUFFER_SIZE ) ) {
  print $buffer;
}
close IMAGE;

###############################################################################################
###############################################################################################