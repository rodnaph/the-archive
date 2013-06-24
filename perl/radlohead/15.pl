#############################################################
#############################################################
##
##  15.pl
##
#############################################################
#############################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant HELP_DIR => BASE . 'files/help/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle;

#############################################################

require(BASE . "lib/output.lib");
require(BASE . "lib/Request.pm");

#############################################################

my $q = new Request;

#############################################################
#############################################################

header("Help");
open_tr();

{
  my $fh = new FileHandle(HELP_DIR . $q->param("topic") . ".txt");
  local $/ = undef;
  my $text = <$fh>;

  ##
  ##  format...
  ##

  $text =~ s/<help>(.*)<\/help>/ help_html($1) /ieg;
  $text =~ s/<sub>(.*)<\/sub>/<p><font size="2"><b>$1<\/b><\/font><br>/ig;
  $text =~ s/<mail>(.*)<\/mail>/<a href="mailto:$1">$1<\/a>/ig;

  ##
  ##  output...
  ##

  if ($text) {
    print_text($text);
  } else {

    heading("no help topic");
    print_text("Sorry, but there is no help topic with that title.");

  }
}

footer();

#############################################################
#############################################################