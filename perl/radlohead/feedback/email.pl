###############################################################################################
###############################################################################################
##
##  email.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant EMAIL_FILE => BASE . 'files/email.nfo';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( print );
use Request;
use Dispatch;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request;
my $d = new Dispatch;

###############################################################################################

$d->load(
         -send => \&send
        );

$d->execute( $q->param('todo') );

###############################################################################################
##
##  send()
##
###############################################################################################

sub send {

  my $name = $q->param('name');
  my $email = $q->param('email');
  my $message = $q->param('message');
  my $subject = $q->param('subject');
  my $fh = new FileHandle( EMAIL_FILE, '>' );

  $message =~ s/\n/<br \/>/g;
  $fh->print( "$name:#:$email:#:$message:#:$subject\n" );
  $fh->close();

  my $text = <<EOT;

<p>
Thank you for your feedback, we'll get back to you as soon as possible.
</p>

EOT

  header( 'Contact Email Sent' );
  open_tr();
  print_box( 'Email Sent', $text );
  footer();

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  my $subject = $q->param('subject');

  my $text = <<EOT;

<p>
If you have any complaints, comments, suggestions, questions, abuses,
whatever...just use the form below to tell us just how you feel
and we'll see what we can do about it.
</p>


EOT

  header( 'Email' );
  open_tr();
  start_box( 'Contacting Us' );
  print_text( $text );

  start_form( 'email.pl' );
  hidden_field( 'todo', 'send' );
  text_field( 'name' );
  text_field( 'subject', 'subject', '','', $subject );
  text_field( 'email' );
  text_area( 'message' );
  end_form( 'SEND');

  end_box();
  footer();

}

###############################################################################################
###############################################################################################