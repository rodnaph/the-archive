#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  mailout.pl
##
###############################################################################################
###############################################################################################

use strict;
use CGI;
use FileHandle qw( getline );

use constant LIST => 'data/mailing_list.txt';

###############################################################################################

require 'lib/stdout.lib';

###############################################################################################

my $q = new CGI;
my $sendmail = '/usr/lib/sendmail';
my $subject = 'SKINFLOWERS MAILOUT!';  # that's the email subject
my $your_email = 'whatever@skinflowers.org';

###############################################################################################
##
##  send the emails...
##
###############################################################################################

if ( $q->param('send') ) {

  my $message = $q->param('message');
  my $fh = new FileHandle( LIST );

  while( my $email = $fh->getline() ) {

    chomp( $email );
    open MAIL, "| $sendmail -t -i -odq" or die "Couldn't open sendmail";
    print MAIL <<EOT;
To: $email
From: $your_email
Subject: $subject

$message

EOT
    close MAIL;

  }

  print get_header( 'Mailout' );
  print <<EOT;

<p>
 The mailout has been sent!
</p>

EOT
  print get_footer();

}

###############################################################################################
##
##  draw the mailout form...
##
###############################################################################################

else {

  print get_header( 'Mailout' );
  print <<EOT;

<p>
Enter the email text...
</p>

<form method="post" onsubmit="return confirm('Sure ???')" action="mailout.pl">
 <input type="hidden" name="send" value="yes" />
 <textarea name="email" cols="80" rows="20"></textarea>
 <br />
 <br />
 <input type="submit" value="SEND" />
</form>

EOT
  print get_footer();

}

###############################################################################################
###############################################################################################