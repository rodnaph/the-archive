
use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant FILE => BASE . 'alt/Local/ip.txt';

use CGI;
use FileHandle qw( print );

my $q = new CGI;
my $fh = new FileHandle( FILE, '>' );
my $ip = $ENV{HTTP_X_FORWARDED_FOR};

$fh->print( $ip );
$fh->close();

print $q->header( -type => 'text/html' ),
      qq{

<html>
<head>
<title>IP Set!</title>

</head>

<body>

<h2>IP Set!</h2>

<p>
IP: $ip
</p>

</body>
</html>

      };

# end