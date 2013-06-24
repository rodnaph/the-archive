########################################################
########################################################
##
##  build_file_index.pl
##
########################################################
########################################################

use strict;
use DirHandle;
use FileHandle;

########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant PROFILES_DIR => BASE . "profiles/";
use constant TO_INDEX_FILE => BASE . "files/files_to_index.txt";

########################################################
########################################################

my $fh = new FileHandle(TO_INDEX_FILE,">");
my $dh = new DirHandle(BASE . "profiles/");

while(my $file = $dh->read()) {
  if ($file !~ /^(\.)+$/) { print $fh "$file\n"; }
}

$dh->close();
$fh->close();

print "Content-type: text/html\n\nTO EDIT file built successfully!";

########################################################