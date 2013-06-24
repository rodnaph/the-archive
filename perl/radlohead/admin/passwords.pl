##################################################
##################################################
##
##  passwords.pl
##
##################################################
##################################################

use strict;
use CGI;
use FileHandle;

##################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant EMAIL_RECOV_FILE => BASE . "files/email_recovery.nfo";

##################################################

my $q = new CGI;

##################################################
##################################################

print <<EOT;
Content-type: text/html

<html>
<head>
<title>PASSWORD RECOVERY</title>
</head>

<body>

<p><hr><hr><p>

EOT

##################################################

if (my $username = $q->param("username")) {

  my $found = 0;

  my $fh = new FileHandle(EMAIL_RECOV_FILE);
  while(my $info = <$fh>) {
    if ($info =~ /^$username:#:/i) {

      my ($name,$email) = split(/:#:/,$info);
      print "NAME: $name<br>EMAIL: $email";

      $found = 1;
      last;
    }
  }

  if (!$found) {
    print "$username NOT FOUND";
  }

  print "<p><hr><hr>";

}

##################################################

print <<EOT;

<form method="POST" action="passwords.pl">

 username : <input type="text" name="username">

 <input type="submit" value="GET EMAIL">

</form>

<p><hr><hr>

</body>
</html>
EOT

##################################################
##################################################