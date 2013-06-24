#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  register.pl
##
###############################################################################################
###############################################################################################

use strict;

use lib ( 'lib' );
use CGI;

###############################################################################################

require 'users.lib';

###############################################################################################

my $q = new CGI();

###############################################################################################

print get_header( 'Message Board Registration' ),
      qq{

<p>
[
<a href="/msgboard">msgboard</a> |
<a href="/cgi-bin/register.pl">register</a>
]
</p>

      };

###############################################################################################
##
##  try and register user...
##
###############################################################################################

if ( $q->param('RegisterUser') ) {

  if (
       user_exists( $q->param('name') ) ||
       ( $q->param('pass1') ne $q->param('pass2') )
     ) {

    ##
    ##  username already taken
    ##

    print qq{

<p>
Sorry, but the either username you are trying to register has already been registered
by someone else, or the password you gave did not match.  Please try again.
</p>

    };

  }
  else {

    ##
    ##  add the user to the system
    ##

    add_user( $q->param('name'), $q->param('pass1') );

    print qq{

<p>
Success!  You have registered the username <b>@{[ $q->param('name') ]}</b>.  This
username now requires the password you gave whenever it is used.
</p>

    };

  }

}

###############################################################################################
##
##  otherwise draw the signup page
##
###############################################################################################

else {

  print qq{

<p>
To register a username, just fill in the relevant details in the form below
and hit the register button.
</p>

<form method="post" action="/cgi-bin/register.pl">

  <input type="hidden" name="RegisterUser" value="yes" />

  <b>Name:</b><br />
  <input type="text" name="name" size="58" maxlength="60" />

  <br /><b>Password:</b><br />
  <input type="password" name="pass1" size="58" maxlength="60" />

  <br /><b>Password Again:</b><br />
  <input type="password" name="pass2" size="58" maxlength="60" />

  <br /><br />

  <input type="submit" value="Register" />
  <input type="reset" value="Reset" />

</form>

        };

}

print get_footer();

###############################################################################################
###############################################################################################