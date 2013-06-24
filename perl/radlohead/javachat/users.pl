
use strict;

use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

my $users;

{
  local $/ = undef;
  open FILE, BASE . "users.txt";
  $users = <FILE>;
  close FILE;
}

##
##  OUTPUT
##

print "Content-type: text/html\n\n$users";