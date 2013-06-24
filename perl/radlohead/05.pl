##################################################
##################################################
##
##  05.pl
##
##################################################
##################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use Request;
use FileHandle;

##################################################

require 'output.lib';

##################################################

my $q = new Request();
my $username = $q->param("username");
trim($username);

##################################################

header( 'Delete', '','', 'Profiles' );
open_tr();

##################################################
##
##  DELETING USER
##
##################################################

if ($q->param("todo") eq "delete") {
  if (validUser($username, $q->param("password"))) {

    ##
    ##  DELETING USER
    ##

    my $color = delete_user($username);
    dec_counter("users");

    ##
    ##  SUCCESS OUTPUT
    ##

    start_box("Username Deleted");
    print_text("Success, the username <b><font color=\"#$color\">" .
               "$username</font></b> is no longer on the system, it" .
               "is free for others to register.");
    end_box();

  }
  else {

    ##
    ##  INVALID USER
    ##

    my $text = <<EOT;

<p>Sorry but that was not a valid username/password combination.  Either you
entered the password for that username incorrectly, or the username you
entered is not currently on the system.</p>

<p>Please <a href="javascript:history.back(1)">click here</a> to try again.</p>

EOT

    print_box("Input Error", $text);

  }
}

##################################################
##
##  DELETION FORM
##
##################################################

else {

  my $text = <<EOT;

<p>If you are the owner of a username you no longer want then just
use the form below to remove it from the system.</p>

<p><b><font color="#FF0000">WARNING</font></b> - This process is
unrecoverable, we cannot get your profile back after you have
deleted the username.</p>

EOT

  start_box("Deleting a Username");
  print_text($text);

  start_form("05.pl");
  hidden_field("todo","delete");
  text_field("username","username",60,30);
  password_field("password","password",60,30);
  end_form("DELETE");
  end_box();

}

footer();

##################################################
##
##  delete_user(username) : scalar
##
##################################################

sub delete_user {

  my ($username) = @_;

  my ($color);

  ##
  ##  REMOVE USER
  ##

  my $user_file = getUserFile($username);
  my $temp_file = get_temp("delete_user.tmp");

  {

    my $fh = new FileHandle($user_file);
    my $fh_temp = new FileHandle($temp_file, ">");

    while(my $user = <$fh>) {
      if ($user =~ /^$username:#:/i) {
        (my $username,my $password,$color) = split(/:#:/,$user);
      } else {
        print $fh_temp $user;
      }
    }

  }

  copy_file($temp_file,$user_file);

  return process_color($color);
}

##################################################