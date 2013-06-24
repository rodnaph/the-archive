#########################################################
#########################################################
##
##  add_book.pl
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

#########################################################
#########################################################

bookclub_header();

#########################################################
##
##  try adding book to database
##
#########################################################

if ($q->param("todo") eq "add_book") {

  if (validUser($q->param("username"),$q->param("password"))) {

    if ($q->param("author") && $q->param("title") && $q->param("email")) {

      ##
      ##  add book to database
      ##

      my $rh_book = {
                      "AUTHOR" => $q->param("author"),
                      "TITLE" => $q->param("title"),
                      "USERNAME" => $q->param("username"),
                      "EMAIL" => $q->param("email")
                    };
      add_book($rh_book);

      ##
      ##  output
      ##

      heading("book added");
      print_text("Success! <b><font color=\"#" . getUserColor($q->param("username")) . "\">" . $q->param("username") . "</font></b>, " .
                 "you have added the following information to the book database.<br /><br />");
      print_text("<b><font color=\#FF0000\">AUTHOR</font></b> : " . $q->param("author") . "<br />");
      print_text("<b><font color=\#FF0000\">TITLE</font></b> : " . $q->param("title") . "<br />");
      print_text("<b><font color=\#FF0000\">EMAIL</font></b> : " . $q->param("email") . "<br />");


    } else {

      ##
      ##  fields missing
      ##

      heading("input error");
      print_text("Sorry <b><font color=\"#" . getUserColor($q->param("username")) . "\">" . $q->param("username") . "</font></b>, " .
                 "but you did not complete all the required fields. Please try again.");

    }

  } else {

    ##
    ##  input error
    ##

    heading("input error");
    print_text("Sorry, but you did not enter a valid username/password combination.  Please try again.");

  }

}

#########################################################
##
##  draw the form
##
#########################################################

else {

  heading("adding a book");

  print_text("To add a book to the database just fill in the form below.  Remember that the " .
             "email will need to be CORRECT if people are to be able to lend this book off you.");

  start_form("add_book.pl");
  hidden_field("todo","add_book");
  text_field("username");
  password_field("password");
  text_field("author");
  text_field("title");
  text_field("your email","email");
  end_form("ADD BOOK");

}

footer();

#########################################################