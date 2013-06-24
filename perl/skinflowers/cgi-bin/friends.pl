#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  friends.pl
##
###############################################################################################
###############################################################################################

use strict;

use CGI::Carp qw( fatalsToBrowser );
use CGI;
use FileHandle qw( print );

use constant LOG => 'data/friends_log.txt';

###############################################################################################

require 'lib/stdout.lib';

###############################################################################################

my $q = new CGI;

my $heading = 'tell your friends ...';
my $subject = 'recommending skinflowers.org';
my $sendmail = '/usr/sbin/sendmail';
my $tell = 4;
my $mail_message = <<EOT;

http://www.skinflowers.org

fine awkward rock. free mp3s and ogg audio, rm video
stuff, the free skinmail email service (get yourself
a user\@skinmail.co.uk email account) and randomness
galore at the skinflowers message board. take a look.

EOT

##        GARY !!!!!!!
##
##  remember that if ya put an @ in here anywhere, u hafta put a \ before
##  it, line... \@
##
##  else it'll not vvork.
##

###############################################################################################
##
##  send the emails...
##
###############################################################################################

if ( $q->param('send') ) {

  ##
  ##  send emails...
  ##

  my $fh_log = new FileHandle( LOG, '>>' );
  my $from_name = $q->param('your_name');
  my $from_email = $q->param('your_email');

  $fh_log->print( "$from_name: $from_email\n" );

  for ( my $i=0; $i<$tell; $i++ ) {

    local *MAIL;

    my $email = $q->param("friend_email_$i");
    my $name = $q->param("friend_name_$i");

    open MAIL, "| $sendmail -t -i -odq" or die "couldn't open sendmail";
    print MAIL <<EOT;
To: $email
From: $from_email
Subject: $subject

$mail_message

sent via the tell people option at
http://www.skinflowers.org

EOT
  close MAIL;

  $fh_log->print( "  $name: $email\n" );

  }

  $fh_log->close();

  ##
  ##  output...
  ##

  print get_header( $heading );
  print <<EOT;

<center>
 <h1>thanks :D</h1>

 <p>message sent. you can close this window now ...</p>

EOT
  print get_footer();

}

###############################################################################################
##
##  draw the send form...
##
###############################################################################################

else {

  ##
  ##  header...
  ##

  print get_header( $heading );
  print <<EOT;

<center>
you can use this form to tell your friends about skinflowers.org. enter
your e-mail address and your friend's e-mail address, and click submit ...
</center>

<form method="post" action="friends.pl">
 <input type="hidden" name="send" value="yes" />
 <table align="center" cols="2">
  <tr>
   <td>
    your name:<br />
    <input type="text" name="your_name" value="" />
   </td>
   <td>
    your email:<br />
    <input type="text" name="your_email" value="" />
   </td>
EOT

  ##
  ##  draw email fields...
  ##

  for ( my $i=0; $i<$tell; $i++ ) {
    print <<EOT;
  <tr>
   <td>
    friend #@{[$i+1]}'s name:<br />
    <input type="text" name="friend_name_$i" value="" />
   </td>
   <td>
    friend #@{[$i+1]}'s email:<br />
    <input type="text" name="friend_email_$i" value="" />
   </td>
  </tr>
EOT
  }

  ##
  ##  footer...
  ##

  print <<EOT;

  <tr>
   <td colspan="2" align="center">
    <input type="submit" value="tell them!" />
    <input type="reset" value="reset" />
   </td>
  </tr>
 </table>
</form>

EOT
  print get_footer();

}

###############################################################################################
###############################################################################################