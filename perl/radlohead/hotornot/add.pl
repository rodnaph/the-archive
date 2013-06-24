###############################################################################################
###############################################################################################
##
##  add.pl
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
##  attempt to add the user...
##
###############################################################################################

if ( $q->param("do_add") ) {

  if ( (validUser( $q->param("username"), $q->param("password") )) &&
       ($q->param("url")) ) {

    my $id = add_picture( $q->param("username"), $q->param("url") );
    heading( "picture added" );
    print_text( user_html($q->param("username")) . ", you have added a picture to the " .
               "HotOrNot section.  People can now vote on this picture, and you can login " .
               "to see how you've done." );
    print_text( "<br /><br />You can link directly to your picture with the following url..." .
                "<br /><br /><i>http://www.radlohead.com/hotornot/vote.pl?id=$id</i>" );
    print_text( "<br /><br />Please don't take it too seriously, just have fun." );

  } else {

    heading( "invalid input" );
    my $text = <<EOT;

<p>Sorry but the form you submitted was not filled in correctly, this could have been for
one of the following reasons.

<ul>
  <li>You entered an invalid username/password combination</li>
  <li>You missed out a required field</li>
</ul>

</p>

EOT
    print_text( $text );

  }

}

###############################################################################################
##
##  draw the add form...
##
###############################################################################################

else {

  heading( "adding your picture" );

  print_text( "To add your picture to the HotOrNot system, just fill in the form " .
              "below and click ADD." );

  start_form( "add.pl" );
  hidden_field( "do_add", "yes" );
  text_field( "username" );
  password_field( "password" );
  text_field( "picture url", "url", "", 100 );
  end_form( "ADD" );

}

footer();

###############################################################################################
###############################################################################################