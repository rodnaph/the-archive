##################################################
##################################################
##
##  09.pl
##
##################################################
##################################################

use strict;
use FileHandle qw( print getline );

##################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant LIB => BASE . "lib/";

##################################################

use lib ( LIB );
use Request;

require "mailbox.lib";

##################################################

my $q = new Request;
my ($rh_mailbox_info, $valid_user);

##################################################

if (validUser($q->param("username"),$q->param("password"))) {
  $valid_user = 1;
  $rh_mailbox_info = {
                       "ACTIONS" => ["inbox","compose","problems"],
                       "USERNAME" => encrypt($q->param("username")),
                       "PASSWORD" => encrypt($q->param("password"))
                     };
} elsif (validUser(decrypt($q->param("username")),decrypt($q->param("password")))) {
  $valid_user = 1;
  $rh_mailbox_info = {
                       "ACTIONS" => ["inbox","compose","problems"],
                       "USERNAME" => $q->param("username"),
                       "PASSWORD" => $q->param("password")
                     };
}

##################################################

header( 'Mailbox', $rh_mailbox_info, '', 'Mailbox' );

##################################################
##
##  DRAW THE LOGIN FORM
##
##################################################

if ($q->param("todo") eq "") {

  open_tr();

  start_box( 'Mailbox Login', 'Mailbox' );

  start_form("09.pl");
  hidden_field("todo","login");
  text_field("username","username");
  password_field("password","password");
  end_form("LOGIN");

  end_box();

}

##################################################
##
##  LOGGING IN
##
##################################################

elsif ($q->param("todo") eq "login") {
  if ($valid_user) {

    ##
    ##  DRAW MAILBOX
    ##

    #mailboxMenu($q->param("username"),$q->param("password"));

    my $unread = get_unread( $q->param("username") );
    my $name = getUsername( $q->param("username") );

    open_tr();
    heading("mailbox for <font color=\"#" . getUserColor($q->param("username")) . "\">$name</font>");
    print_text("welcome back, you have <font size=\"+2\">$unread</font> unread message(s) in your inbox.");

  } else { invalidUser(); }
}

##################################################
##
##  INBOX
##
##################################################

elsif ($q->param("todo") eq "inbox") {

  if ($valid_user) {

    #mailboxMenu(decrypt($q->param("username")),decrypt($q->param("password")));

    open_tr();

    inboxMessages(decrypt($q->param("username")),decrypt($q->param("password")));

  } else { invalidUser(); }
}

##################################################
##
##  COMPOSE
##
##################################################

elsif ($q->param("todo") eq "compose") {

  if ($valid_user) {

    #mailboxMenu(decrypt($q->param("username")),decrypt($q->param("password")));

    my $encName = $q->param("username");
    my $encPass = $q->param("password");

    open_tr();
    start_box( 'Compose', 'Mail::Compose' );

    start_form("09.pl");
    hidden_field("todo","send");
    hidden_field("username",$encName);
    hidden_field("password",$encPass);
    text_field("send to","sendto");
    text_field("subject","subject");
    text_area("message","message");
    end_form("SEND MESSAGE");

    end_box();

  } else { invalidUser(); }
}

##################################################
##
##  SEND MESSAGE
##
##################################################

elsif ($q->param("todo") eq "send") {

  if ($valid_user) {

    #mailboxMenu(decrypt($q->param("username")),decrypt($q->param("password")));

    if (userExists($q->param("sendto"))) {

      ##
      ##  SEND MESSAGE
      ##

      sendMessage($q->param("sendto"),decrypt($q->param("username")),$q->param("subject"),$q->param("message"));

      ##
      ##  OUTPUT
      ##

      my $sendto = $q->param("sendto");
      my $toColor = getUserColor($sendto);
      my $encTo = URLEncode($sendto);

      open_tr();
      print_text("<b>message to <b><a href=\"07.pl?profile=$encTo\"><font color=\"#$toColor\">$sendto</font></a><b> sent</b>");

      inboxMessages(decrypt($q->param("username")),decrypt($q->param("password")));

    } else {

      ##
      ##  SENDTO INVALID
      ##

      my $sendto = $q->param("sendto");

      my $text = <<EOT;

<p>Sorry, but the username <b>$sendto</b> isn't on the system.

<p>Please <a href="javascript:history.back(1)">click here</a> to go back and try again.

EOT

      open_tr();
      print_box( 'Invalid Address', $text, 'Mail::Send' );

    }

  } else { invalidUser(); }

}

##################################################
##
##  PROBLEMS
##
##################################################

elsif ($q->param("todo") eq "problems") {

  if ($valid_user) {

    #mailboxMenu(decrypt($q->param("username")),decrypt($q->param("password")));

    open_tr();
    heading("problems");
    print_text("If your having any problems with the messaging system, just tell us" .
               "using the form below, and please try to be as detailed as you can.");

    start_form("09.pl");
    hidden_field("todo","send");
    hidden_field("username",$q->param("username"));
    hidden_field("password",$q->param("password"));
    hidden_field("sendto","m0ren0");
    hidden_field("subject","Message System Problem");
    text_area("problem","message",50,10);
    end_form("REPORT PROBLEM");

  } else { invalidUser(); }
}

footer();

##################################################
##
##  get_unread( username )
##
##################################################

sub get_unread {

  my ( $username ) = @_;

  my $unread = 0;

  my $fh = new FileHandle( getMailbox( $username ) );
  while( my $message = $fh->getline() ) {
    if ($message =~ /^$username:#:.*0$/) { $unread++; }
  }
  $fh->close();

  return $unread;

}

##################################################