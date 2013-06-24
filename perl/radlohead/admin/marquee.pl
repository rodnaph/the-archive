###############################################################################################
###############################################################################################
##
##  marquee.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant MARQUEE_FILE => BASE . 'files/marquee.txt';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline print );
use Request;

###############################################################################################

my $q = new Request;
my $content = $q->param('content');

###############################################################################################

# do updating
if ( $q->param('update') ) {
  my $fh = new FileHandle( MARQUEE_FILE, '>' );
  $fh->print( $content );
}

# get content
{
  local $/ = undef();
  my $fh = new FileHandle( MARQUEE_FILE );
  $content = $fh->getline();
}

print <<EOT;
Content-type: text/html

<html>
<head>
<title>Marquee</title>
<link href="Admin.css" rel="stylesheet" type="text/css" />
</head>

<body>

<h2>Marquee</h2>

<hr />

<p>

<form method="post" action="marquee.pl">
 <input type="hidden" name="update" value="yes" />
 marquee: <textarea cols="80" rows="15" name="content">$content</textarea>
 <br /><br />
 <input type="submit" value="UPDATE" />
</form>

</p>

</body>
</html>
EOT

###############################################################################################
###############################################################################################