##################################################
##################################################
##
##  email.pl
##
##################################################
##################################################

use strict;
use FileHandle;

##################################################

use constant BASE => "f:/newmind/radiohead/";

use constant HITS_DB => BASE . "files/counters/profiles_views";

##################################################

print <<EOT;
Content-type: text/html

<html>
<head>
</head>

<body>

<table border="3">
  <tr>
    <th>USER</th>
    <th>HITS</th>
  </tr>
EOT

my $count = 0;

dbmopen my %db, HITS_DB, 0666;
foreach my $key (keys %db) {

  print "<tr><td>$key</td><td>" . $db{$key} . "</td></tr>\n";
  $count++;

}
dbmclose %db;

print <<EOT;
</table>

<h3>$count profile hits total</h3>

</body>
</html>
EOT

##################################################