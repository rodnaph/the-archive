###############################################################################################
###############################################################################################
##
##  journal.pl
##
###############################################################################################
###############################################################################################

use strict;

###############################################################################################

use constant BASE => 'e:/sites/radlohead/';
use constant LIB => BASE . 'journals/lib';
use constant MAX_ENTRIES => 3;
use lib ( LIB );

###############################################################################################

require 'output.lib';
require 'main.lib';

###############################################################################################

my $q = new Request();
my $journal = $q->param('user');
my %entries;
my $created;
my $top_text;
my $max = 0;
my $min = 9999999999999999;

###############################################################################################

if (!has_journal($journal)) {
  require CGI;
  my $q = new CGI;
  print $q->redirect('main.pl');
}

j_header();

my $heading = 'Journal For ' . user_html($journal);

##
##  load entries...
##

dbmopen my %db, get_journal_file($journal), get_journal_perms();

$created = $db{created};
$top_text = $db{text};
$top_text =~ s/\n/<br \/>/g;
if ( $top_text ) { print_box( $heading, $top_text ); } else { heading( $heading ); };

foreach my $entry ( keys %db ) {
  if ( $entry !~ /(created|text)/ ) {
    $entries{$entry} = $db{$entry};
    if ( $entry > $max ) { $max = $entry; }
    if ( $entry < $min ) { $min = $entry; }
  }
}

dbmclose %db;

##
##  display entries
##

my $i = $max;
my $count = 0;
my $page = 1;
$page = $q->param('page') unless !$q->param('page');

##
##  wind...
##

my $to_skip = ($page-1) * MAX_ENTRIES;
while ($to_skip && ($i>=$min)) {
  if ( $entries{$i--} ) { $to_skip--; }
}

##
##  draw...
##

if ($i<$min) {
  print_box( 'New Journal', 'This user has not yet added any entries to their journal.' );
}

while( ($i >= $min) && ($count < MAX_ENTRIES) ) {

  if ( $entries{$i} ) {
    $entries{$i} =~ s/\n/<br \/>/g;
    my $title = gmtime($i);
    print_box( $title, $entries{$i} );
    $count++;
  }
  $i--;
}

print_html( '<p>' );
if ( $page > 1 ) { print_text( '<a style="text-decoration:none;" href="journal.pl?user=' . $journal . '|page=' . ($page-1) . '"><b>BACK</b></a>' ); };
if ( ($page>1) && ($i>$min) ) { print_text( ' <b>|</b> ' ) };
if ( $i > $min ) { print_text( '<a style="text-decoration:none;" href="journal.pl?user=' . $journal . '|page=' . ($page+1) . '"><b>MORE</b></a>'); };
print_html( '</p>' );

print_text( '<p>Journal created on <b>' . gmtime($created) . '</b></p>' );

footer();

###############################################################################################
###############################################################################################