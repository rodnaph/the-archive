#########################################################
#########################################################
##
##  main.pl
##
#########################################################
#########################################################

use strict;

#########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

#########################################################

require(BASE . "lib/system.lib");
require(BASE . "bookclub/lib/output.lib");
require(BASE . "bookclub/lib/book_db.lib");
require(BASE . "lib/Request.pm");

#########################################################

my $q = new Request;
my $username = $q->param("username");

#########################################################
#########################################################

#########################################################
##
##  draw the page header
##
#########################################################

bookclub_header();

#########################################################
##
##  if logged in...
##
#########################################################

if (validUser($username,$q->param("password"))) {

  ##
  ##  do updating...
  ##

  if ($q->param("todo") eq "delete_book") {
    delete_book($q->param("id"));
  } elsif ($q->param("todo") eq "change_availability") {
    change_availability($q->param("id"));
  }

  ##
  ##  draw users books...
  ##

  heading("books for " . user_html($q->param("username")));
  print_text("<p>To delete a book or change is availability just click on the buttons " .
             "by each of the books that are listed.</p>");

  my $ra_books = get_books();
  foreach my $rh_book (@$ra_books) {
    if ($rh_book->{'USERNAME'} =~ /^$username$/i) {

      draw_book($rh_book);

      print_html("<table><tr><td>");

      start_form("manage_books.pl");
      hidden_field("username",$username);
      hidden_field("password",$q->param("password"));
      hidden_field("id",$rh_book->{'ID'});
      hidden_field("todo","change_availability");
      end_form("CHANGE AVAILABILITY");

      print_html("</td><td>");

      start_form("manage_books.pl");
      hidden_field("username",$username);
      hidden_field("password",$q->param("password"));
      hidden_field("id",$rh_book->{'ID'});
      hidden_field("todo","delete_book");
      end_form("DELETE BOOK");

      print_html("</td></tr></table>");

    }

  }

}

#########################################################
##
##  login form
##
#########################################################

else {

  heading("manage books login");
  print_text("To login and manage the books you own just enter your details into the form below and click ");
  print_submit("LOGIN");

  start_form("manage_books.pl");
  text_field("username");
  password_field("password");
  end_form("LOGIN");

}

#########################################################
##
##  footer
##
#########################################################

footer();

#########################################################