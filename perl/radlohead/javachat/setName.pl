
use strict;
use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

use CGI;

my $q = new CGI;

my $old = $q->param("old");
my $new = $q->param("new");

##
##  CHANGE NAME
##

my $changed = 0;

@ARGV = (BASE . "users.txt");
$^I = ".bk";
while(<>) {
  if ((/^$old\n/) && (!$changed)) { $changed = 1; print "$new\n"; }
    else { print; }
}

##
##  INFORM USERS OF CHANGE
##

chdir (BASE . "sessions");
while(<*>) {
  open FILE, ">>" . BASE . "sessions/" . $_;
  print FILE "$old IS NOW KNOWN AS $new\n";
  close FILE;
}

##
##  OUTPUT
##

print "Content-type: text/html\n\n";