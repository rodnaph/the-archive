###############################################################################################
###############################################################################################
##
##  yours.pl
##
###############################################################################################
###############################################################################################

use strict;

###############################################################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

###############################################################################################

require(BASE . "hotornot/lib/output.lib");
require(BASE . "hotornot/lib/db.lib");
require(BASE . "lib/Request.pm");

###############################################################################################

my $q = new Request;

###############################################################################################

hotornot_header();

###############################################################################################
##
##  attempt login
##
###############################################################################################

if ( $q->param("login") ) {

  my $rh_pic = get_pic( $q->param("username") );

  if ( (validUser($q->param("username"), $q->param("password"))) &&
       ($rh_pic->{'url'})) {

    heading( user_html( $q->param("username") ) );
    print_text( "<br /><b>VOTES:</b> $rh_pic->{'votes'}" );
    print_text( "<br /><b>SCORE:</b> $rh_pic->{'score'}" );

  } else {

    heading( "input error" );
    print_text( "Sorry, but either you did not enter a valid username/password combination, " .
                "or you have not registered a picture with the hotornot section." );
  }

}

###############################################################################################
##
##  draw login form
##
###############################################################################################

else {

  heading( "your picture" );
  print_text( "To login and view the statistics for your picture just use the form below." );

  start_form( "yours.pl" );
  hidden_field( "login", "yes" );
  text_field( "username" );
  password_field( "password" );
  end_form( "LOGIN" );

}

footer();

###############################################################################################
###############################################################################################