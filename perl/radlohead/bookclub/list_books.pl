#########################################################
#########################################################
##
##  list_books.pl
##
#########################################################
#########################################################

use strict;

#########################################################

use constant BASE => "f:/newmind/radiohead/";
use constant LIB => BASE . 'lib';
use constant BOOKS_PER_PAGE => 15;
use lib ( LIB );

#########################################################

require(BASE . "bookclub/lib/output.lib");
require(BASE . "bookclub/lib/book_db.lib");
require(BASE . "lib/Request.pm");

#########################################################

my $q = new Request;
my $page = $q->param("page");
$page = 1 unless $page;

#########################################################
#########################################################

#########################################################
##
##  draw the top of the page
##
#########################################################

bookclub_header(1);

#########################################################
##
##  draw pages links and heading text...
##
#########################################################

open_tr();

my ($ra_books,$book_count) = get_books();

{
  print '[ ';
  my ($i,$page) = (1,1);
  while ($i < $book_count) {
    print ' <a href="/bookclub/list_books.pl?page=' . $page . '">' . $page . '</a>';
    if ( $i < ($book_count - BOOKS_PER_PAGE) ) { print ' | '; }
    $page++;
    $i += BOOKS_PER_PAGE;
  }
  print ' ]';
}

heading("book list - page $page");
print_text("Below is a list of books stored on our database, for information on " .
           "how to lend out the books look on the main page.");

#########################################################
##
##  output book list
##
#########################################################

my @books = @$ra_books;

my $from = ($page - 1) * BOOKS_PER_PAGE;
my $to = $page * BOOKS_PER_PAGE;
if ($to > $book_count) { $to = $book_count; }

print_text("<p><i>(viewing " . ($from + 1) . " to $to of $book_count books)</i></p>");

for (my $i=$from; $i<$to; $i++) {
  draw_book($books[$i]);
}

#########################################################
##
##  footer
##
#########################################################

footer();

#########################################################