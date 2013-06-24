#!/usr/bin/perl

########################################################
########################################################
##
##  news.pl
##
########################################################
########################################################

use strict;
use CGI;
use FileHandle qw( print getline );

use constant NEWS_FILE => '../www/news.txt';

########################################################

require 'stdout.lib';

########################################################

my $q = new CGI;
my $text;

########################################################

print get_header( 'News' );

##
##  update the news file...
##

if ( $q->param('update') ) {

  my $news = $q->param('news');
  my $fh = new FileHandle( NEWS_FILE, '>' );

  $fh->print( $news );

  print "<h2>NEWS UPDATED!</h2>";

}

##
##  draw the page
##

{
  local $/ = undef;
  my $fh = new FileHandle( NEWS_FILE );
  if ($fh) { $text = $fh->getline(); }
}

print <<EOT;

<h2>Updating News</h2>

<p>Just edit the shtuff below and click update.  It will write to a file 'news.txt' in the main directory.</p>

<form method="post" action="news.pl">
  <input type="hidden" name="update" value="yes" />
  <textarea name="news" cols="50" rows="20">$text</textarea>
  <br /><br />
  <input type="submit" value="UPDATE" />
</form>

EOT

print get_footer();

########################################################
########################################################