
use strict;
use CGI;

use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

my $q = new CGI;

my ($name,$message) = ($q->param("name"),$q->param("message"));

##
##  UPDATE SESSIONS
##

chdir (BASE . "sessions/");
while(<*>) {

  if (!/\.old$/) {

    open FILE, ">>" . BASE . "sessions/$_";
    print FILE "<" . $name . "> " . $message . "\n";
    close FILE;

  }

}

##
##  OUTPUT
##

print "Content-type: text/html\n\n";
