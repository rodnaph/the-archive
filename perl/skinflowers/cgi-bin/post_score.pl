#!/usr/bin/perl


use strict;
use CGI;
use FileHandle qw( getline print );

use constant BLOG_FILE => '../www/unfinitepong/unfinitepong.txt';
use constant MAX_FILE_SIZE => 900000; # bytes

############################################################################################

my $q = new CGI;
my $old_contents;

my $score = $q->param('score');
my $postedby = $q->param('postedby');
my $date = gmtime( time );
my $message = $q->param('message');

$message =~ s/\n/<br \/>/g;

if ( (-s BLOG_FILE) < MAX_FILE_SIZE ) {

  local $/ = undef;
  my $fh = new FileHandle( BLOG_FILE );
  $old_contents = $fh->getline();

}

my $fh = new FileHandle( BLOG_FILE, '>' );



print $fh <<EOT;
<li>

<font size=+2>$score</font> points gained by <b>$postedby</b> on $date <br /><br />

$message<br /><br />
</li>
EOT
$fh->print( $old_contents );



print $q->redirect( '/unfinitepong/scores.shtml' );

############################################################################################
############################################################################################