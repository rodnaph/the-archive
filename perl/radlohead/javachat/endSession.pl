
use strict;
use CGI;

use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

my $q = new CGI;

##
##  END SESSION
##

my $sID = $q->param("sID");

## system "rm " . BASE . "sessions/" . $sID . ".txt";

##
##  REMOVE NAME FROM FILE
##

my ($name,$found) = ($q->param("name"),0);

@ARGV = (BASE . "users.txt");
$^I=".bk";
while(<>) {
  if ((!/^$name\n/) && (!$found)) { print; } else { $found = 1; }
}

##
##  INFORM USERS OF DEPARTURE
##

chdir (BASE . "sessions");
while(<*>) {
  open FILE, ">>" . BASE . "sessions/" . $_;
  print FILE "$name HAS JUST LEFT\n";
  close FILE;
}

##
##  OUTPUT
##

print "Content-type: text/html\n\n";
