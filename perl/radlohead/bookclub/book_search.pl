#########################################################
#########################################################
##
##  book_search.pl
##
#########################################################
#########################################################

use strict;

#########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

#########################################################

require(BASE . "bookclub/lib/output.lib");
require(BASE . "bookclub/lib/book_db.lib");
require(BASE . "lib/Request.pm");

#########################################################

my $q = new Request;

#########################################################
#########################################################

bookclub_header();

#########################################################
##
##  perform the search
##
#########################################################

if ($q->param("todo") eq "do_search") {

  heading("search results");
  print_text("Listed below are the results of your search using the the " .
             " keywords : <b>" . $q->param("keywords") . "</b>");

  my $ra_books = search_books($q->param("keywords"));

  foreach my $rh_book (@$ra_books) {
    draw_book($rh_book);
  }

}

#########################################################
##
##  draw the search form
##
#########################################################

else {

  heading("book search");
  print_text("To search our database for a certain book/author/etc... you are looking " .
             "for, just enter some words into the form below and click " .
             "<b><font color=\"#AAAAFF\">SEARCH</font></b>");

  start_form("book_search.pl");
  hidden_field("todo","do_search");
  text_field("search keywords","keywords");
  end_form("SEARCH");

}

footer();

#########################################################