#########################################################
#########################################################
##
##  main.pl
##
#########################################################
#########################################################

use strict;
use FileHandle;

#########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant MAIN_FILE => BASE . "bookclub/admin/main.txt";

#########################################################

require(BASE . "lib/system.lib");
require(BASE . "bookclub/lib/output.lib");
require(BASE . "bookclub/lib/book_db.lib");

#########################################################

bookclub_header();

print_text("<font size=\"+2\">bookclub</font> by <b><a href=\"../07.pl?profile=UnleadedBlue\" class=\"profile_link\"><font color=\"#" . getUserColor("UnleadedBlue") . "\">UnleadedBlue</font></a></b><br /><br />");

my ($text);

{
  local $/ = undef;
  my $fh = new FileHandle(MAIN_FILE);
  $text = <$fh>;
}

print_text($text);

footer();

#########################################################