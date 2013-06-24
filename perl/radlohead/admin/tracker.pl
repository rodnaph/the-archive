##################################################
##################################################
##
##  tracker.pl
##
##################################################
##################################################

use strict;

##################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

##################################################

require(BASE . "lib/tracker.lib");

##################################################
##################################################

if ($ENV{'QUERY_STRING'} eq "r=reset_log") { reset_db(); }

my ($rh_tracker_log,$tracked_from,$hits) = get_tracker_log();

print <<EOT;
Content-type: text/html

<html>
<head>
<title>TRACKER LOG</title>

<style>

TD {
  text-align: center;
}

</style>

</head>

<body bgcolor="#BFBFBF">

<p><i>$hits</i> hits tracked from <b>$tracked_from</b>

<table border="3" width="100%">
  <tr>
    <td><b>REMOTE ADDRESS</b></td>
    <td><b>HITS</b></td>
    <td><b>REMOTE HOST</b></td>
    <td><b>HTTP USER AGENT</b></td>
  </tr>

EOT

foreach my $remote_addr (keys %$rh_tracker_log) {

  my ($hits,$remote_host,$http_user_agent) = split(/:#:/,$rh_tracker_log->{$remote_addr});

  print <<EOT;
  <tr>
    <td>$remote_addr</td>
    <td>$hits</td>
    <td>$remote_host</td>
    <td>$http_user_agent</td>
  </tr>
EOT

}

print <<EOT;

</table>

<p><i>END OF LOG</i>

<p>
<form action="tracker.pl" method="GET">
  <input type="hidden" name="r" value="reset_log">
  <input type="submit" value="RESET LOG">
</form>

<form action="tracker.pl" method="GET">
  <input type="submit" value="REFRESH">
</form>

</body>
</html>

EOT

##################################################