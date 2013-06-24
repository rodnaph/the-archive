#########################################################
#########################################################
##
##  admin.pl
##
#########################################################
#########################################################

use strict;
use CGI;
use FileHandle;

#########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant MAIN_FILE => BASE . "bookclub/admin/main.txt";

#########################################################

require(BASE . "lib/output.lib");
require(BASE . "lib/system.lib");

#########################################################

my $q = new CGI;

#########################################################
#########################################################

header();
open_tr();

#########################################################
##
##  admin section
##
#########################################################

if (validUser("UnleadedBlue",$q->param("password"))) {

  if ($q->param("todo") eq "save_changes") {

    my $main_text = $q->param("main_text");
    $main_text =~ s/\n/<br>/g;

    my $fh = new FileHandle(MAIN_FILE,">");
    print $fh $main_text;
    $fh->close();

    print_text("<b>(changes saved)</b>");

  }

  ##
  ##  draw the page
  ##

  heading("logged in");
  print_text("The text you enter into the form below will be the text that appears " .
             "on the main bookclub page.");

  start_form("admin.pl");
  hidden_field("password",$q->param("password"));
  hidden_field("todo","save_changes");
  text_area("main text","main_text",70,30,$q->param("main_text"));
  end_form("SAVE CHANGES");

}

#########################################################
##
##  login page
##
#########################################################

else {

  heading("bookclub admin login");
  print_text("<b><font color=\"#" . getUserColor("UnleadedBlue") . "\">UnleadedBlue</font></b> " .
             "please enter your password to login.");

  start_form("admin.pl");
  password_field("password");
  end_form("LOGIN");

}

footer();

#########################################################