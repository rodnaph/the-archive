###############################################################################################
###############################################################################################
##
##  dbmtool.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';

use lib ( LIB );
use CGI;
use CGI::Carp qw( fatalsToBrowser );
use HashDatabase;

###############################################################################################

my $q = new CGI();
my $dbloc = $q->param('dbloc');

###############################################################################################
##
##  applying changes...
##
###############################################################################################

if ( $q->param('todo') eq 'delete' ) {

  my $key = $q->param('key');
  my $db = new HashDatabase();

  $db->open( $dbloc );
  $db->delete( $key );
  $db->close();

}

if ( $q->param('todo') eq 'add' ) {

  my $key = $q->param('key');
  my $value = $q->param('value');
  my $db = new HashDatabase();

  $db->open( $dbloc );
  $db->set( $key, $value );
  $db->close();

}

###############################################################################################
##
##  header...
##
###############################################################################################

print $q->header( -type => 'text/html' );
print <<EOT;
<html>
<head>
<title>DBMTool</title>
<link href="Admin.css" rel="stylesheet" type="text/css" />
</head>

<body>

<h2>DBMTool</h2>

<form method="post" action="dbmtool.pl">
  <b>DB:</b> <input type="text" name="dbloc" value="$dbloc" size="70" />
  <input type="submit" value="OPEN/REFRESH" />
</form>
EOT

###############################################################################################
##
##  drawing database if needed...
##
###############################################################################################

if ( $dbloc ) {

  print "<hr>";

  my $db = new HashDatabase( $dbloc );
  my $ra_keys = $db->get_keys();

  print "<br /><table border=1><tr><td></td><th>KEY</th><th>VALUE</th></tr>";

  foreach my $key ( @$ra_keys ) {
    print <<EOT;
<tr>
<td>
  <form method="post" action="dbmtool.pl">
    <input type="hidden" name="todo" value="delete" />
    <input type="hidden" name="dbloc" value="$dbloc" />
    <input type="hidden" name="key" value="$key" />
    <input type="submit" value="DELETE" />
  </form>
</td>
<td>$key</td><td>@{[ $db->value($key) ]}</td>
</tr>

EOT
  }

  print "</table>";
  $db->close();

  print <<EOT;
<br /><br />
<hr>
<form method="post" action="dbmtool.pl">
  <input type="hidden" name="todo" value="add" />
  <input type="hidden" name="dbloc" value="$dbloc" />
  <b>KEY: <input type="text" size="50" name="key" />
  <br />
  <b>VALUE: <input type="text" size="50" name="value" />
  <br />
  <input type="submit" value="ADD NEW ENTRY" />
</form>
EOT

}

###############################################################################################
##
##  footer...
##
###############################################################################################

print <<EOT;  

</body>
</html>
EOT

###############################################################################################
###############################################################################################