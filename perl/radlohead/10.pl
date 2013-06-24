##################################################
##################################################
##
##  10.pl
##
##################################################
##################################################

use strict;
use FileHandle;

##################################################

use constant BASE => "f:/newmind/radiohead/";
use constant LIB => BASE . 'lib';
use lib ( LIB );

##################################################

require(BASE . "lib/mailbox.lib");
require(BASE . "lib/Request.pm");

##################################################

my $q = new Request;

##################################################

header( 'Mailbox', '','', 'Mailbox' );
mailboxMenu(decrypt($q->param("username")),decrypt($q->param("password")));

#################################################
##
##  VIEW MESSAGE
##
#################################################

if ($q->param("todo") eq "view") {

  viewMessage(decrypt($q->param("username")),$q->param("msgID"),$q->param("password"),$q->param("read"));

}

#################################################
##
##  DELETE MESSAGE
##
#################################################

elsif ($q->param("todo") eq "delete") {

  my $username = getUsername(decrypt($q->param("username")));
  my $msgID = $q->param("msgID");

  ##
  ##  DELETING MESSAGE
  ##

  {
    my $fh_mail = new FileHandle(getMailbox($username));
    my $fh_temp = new FileHandle(get_temp("deleteMessage.tmp"),">");

    while(my $mail = <$fh_mail>) {
      if (!(($mail =~ /^$username:#:/i) && ($mail =~ /$msgID/))) {
        print $fh_temp $mail;
      }
    }
  }

  copy_file(get_temp("deleteMessage.tmp"),getMailbox($username));

  ##
  ##  OUTPUT
  ##

  open_tr();
  print_text("<b>message deleted</b>");

  inboxMessages($username,decrypt($q->param("password")));

}

#################################################
##
##  REPLY FORM
##
#################################################

elsif ($q->param("todo") eq "reply") {

  my ($username,$encName,$password,$msgID,$sendto,$subject,$message) = (decrypt($q->param("username")), $q->param("username"), $q->param("password"), $q->param("msgID"));

  my $fh = new FileHandle(getMailbox($username));
  while(<$fh>) {
    if ((/^$username:#:/i) && (/$msgID/)) {
      (my $from,$sendto,$subject,$message) = split(/:#:/);
    }
  }
  $fh->close();

  ##
  ##  SETTING VARS
  ##

  my $toColor = getUserColor($sendto);
  my $encTo = URLEncode($sendto);

  ##
  ##  FORMATTING
  ##

  $subject = "RE : " . $subject;
  $message = "> " . $message;
  $message =~ s/<br>/\n> /ig;

  open_tr();
  start_box( "Replying To <b><a class=\"profile_link\" href=\"07.pl?profile=$encTo\">" .
             "<font color=\"#$toColor\">$sendto</font></a></b>", 'Mail::Replying');

  start_form("09.pl");
  hidden_field("todo","send");
  hidden_field("username",$encName);
  hidden_field("password",$password);
  hidden_field("sendto",$sendto);
  text_field("subject","subject",50,50,$subject);
  text_area("message","message",50,10,$message);
  end_form("SEND REPLY");

  end_box();

}

#################################################
##
##  FORWARD FORM
##
#################################################

elsif ($q->param("todo") eq "forward") {

  my $username = decrypt($q->param("username"));
  my $encName = $q->param("username");
  my $password = $q->param("password");
  my $msgID = $q->param("msgID");
  my $subject;
  my $message;

  ##
  ##  GET MESSAGE DATA
  ##

  my $fh = new FileHandle(getMailbox($username));
  while(my $mail_item = <$fh>) {
    if (($mail_item =~ /^$username:#:/i) && ($mail_item =~ /$msgID/)) {
      (my $to, my $from, $subject, $message) = split(/:#:/,$mail_item);
      last;
    }
  }
  $fh->close();

  ##
  ##  FORMATTING
  ##

  $subject = "FWD : " . $subject;
  $message = "> " . $message;
  $message =~ s/<br>/\n/g;

  ##
  ##  DRAW FORM
  ##

  open_tr();

  start_box( 'Forward Message', 'Mail::Forward' );

  start_form("09.pl");
  hidden_field("username",$encName);
  hidden_field("password",$password);
  hidden_field("todo","send");
  text_field("forward to","sendto");
  text_field("subject","",50,50,$subject);
  text_area("message","",50,10,$message);
  end_form("FORWARD MESSAGE");

  end_box();

}

#################################################
##
##  END
##
#################################################

else { invalidUser(); }

footer();
