##################################################
##################################################
##
##  email.pl
##
##################################################
##################################################

use strict;
use FileHandle;
use CGI;

##################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant EMAIL_FILE => BASE . "files/email.nfo";

##################################################

require(BASE . "lib/system.lib");

##################################################

my $q = new CGI;

##################################################
##################################################

print <<EOT;
Content-type: text/html

<html>
<head>
<title>EMAIL</title>
</head>

<body>

EOT

##################################################

if ($q->param("erase")) {

  my $fh = new FileHandle(EMAIL_FILE,">");
  $fh->close();

}

##################################################

print "<hr><hr>";

{
  my $fh = new FileHandle(EMAIL_FILE);
  while(my $email = <$fh>) {
    chomp($email);
    my ($name,$subject,$message) = split(/:#:/,$email);
    print <<EOT;

<h3>$subject</h3>
<b>$name</b>
<blockquote>
  $message
</blockquote>

<p><hr>

EOT
  }
}

print <<EOT;
<hr>

<form method="POST" action="email.pl">
  <input type="hidden" name="erase" value="1">
  <input type="submit" value="ERASE ALL MESSAGES">
</form>

<p><hr><hr>

</body>
</html>
EOT

##################################################