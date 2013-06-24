########################################################################
########################################################################
##
##  slurp_profiles.pl
##
########################################################################
########################################################################

use strict;
use DirHandle;
use FileHandle;

########################################################################

use constant BASE => "f:/newmind/radiohead/";
use constant SLURP_FILE => BASE . "files/profiles_blob.txt";
use constant SLURP_DIR => BASE . "files/profiles/";

########################################################################

my $dh = new DirHandle(SLURP_DIR);
my $fh = new FileHandle(SLURP_FILE,">");

while (my $file = $dh->read()) {

  local *FILE;
  local $/ = undef;

  open FILE, SLURP_DIR . $file;
  my $text = <FILE>;
  close FILE;

  print $fh $text;

}
$fh->close();
$dh->close();

print <<EOT;
Content-type: text/html

<h1>DONE</h1>
EOT

########################################################################
########################################################################