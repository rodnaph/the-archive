
use strict;
use constant BASE => "f:/newmind/radiohead/javachat/";
#use constant BASE => "e:/sites/javachat/";

##
##  GETTING TEXT
##

my ($text,$oldtext);

{
  open FILE, (BASE . "sessions/$ENV{'QUERY_STRING'}.txt");
  local $/ = undef;
  $text = <FILE>;
  close FILE;
}

{
  open FILE, (BASE . "sessions/$ENV{'QUERY_STRING'}.old");
  local $/ = undef;
  $oldtext = <FILE>;
  close FILE;
}

##
##  WRITE OLD DATA
##

open FILE, (">" . BASE .  "sessions/$ENV{'QUERY_STRING'}.old");
print FILE $text;
close FILE;

##
##  OUTPUT
##

my @lines = split(/\n/,$oldtext);

foreach (@lines) {
  $text =~ s/$_//;
}
$text =~ s/\n//g;
$text =~ s/\?//g;

trim($text);

print "Content-type: text/html\n\n$text";

##############################################################
##
##  trim(scalar) : scalar
##
##############################################################

sub trim {
  local $/ = " ";
  while(chomp($_[0])) {}
  $_[0] = reverse($_[0]);
  while(chomp($_[0])) {}
  $_[0] = reverse($_[0]);
}
