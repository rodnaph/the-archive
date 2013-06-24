
use strict;
use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

##
##  CREATE SESSION
##

my $time = time;
open FILE, ">" . BASE . "sessions/$time.txt";
print FILE "";
close FILE;

##
##  ADDING NAME TO LIST
##

open FILE, ">>" . BASE . "users.txt"
  or open FILE, ">" . BASE . "users.txt";
print FILE "NO-NAME\n";
close FILE;

##
##  OUTPUT
##

print "Content-type: text/html\n\n$time";
