#############################################################
#############################################################
##
##  13.pl
##
#############################################################
#############################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( print getline );
use Request;
use Dispatch;

#############################################################

require 'output.lib';

#############################################################

my $q = new Request;
my $d = new Dispatch;

#############################################################

$d->load(
         -change => \&change_password
        );

header( 'Passwords', '','', 'Profiles' );
open_tr();

# dispatching
$d->execute( $q->param('todo') );

footer();

#############################################################
##
##  change_password()
##
#############################################################

sub change_password {

  my $username = $q->param('username');

  if (
       ($q->param('new_pass1') eq $q->param('new_pass2')) &&
       (validUser($username,$q->param('password'))) &&
       ($q->param('new_pass1'))
     ) {

     ##
     ##  change password
     ##

     my $user_file = getUserFile($username);
     my $temp_file = get_temp('change_password');

     {
       my $fh = new FileHandle( $user_file );
       my $fh_temp = new FileHandle( $temp_file, '>' );
       while ( my $user = $fh->getline() ) {
         if ( $user =~ /$username:#:/i ) {

           chomp( $user );
           my ( $username, $password, $color, $has_image ) = split( /:#:/, $user );
           $fh_temp->print( "$username:#:" . $q->param("new_pass1") . ":#:$color:#:$has_image\n" );

         } else { $fh_temp->print( $user ); }
       }
     }

     copy_file( $temp_file, $user_file );

     ##
     ##  user output
     ##

     start_box( 'Password Changed' );
     print_text( 'Success,' );
     print_user( $username );
     print_text( 'you have changed your password.  If you forget it just contact us and we\'ll ' .
                 'help you out.' );
     end_box();

  }

  ##
  ##  input error
  ##

  else {

    my $text = <<EOT;

Sorry, but the information you submitted was not valid for one of the following reaons.

<ul>
  <li>You entered an invalid username/password combination</li>
  <li>You new passwords did not match</li>
  <li>You missed out a field</li>
</ul>

Which ever is the case you will need to try again.

EOT

    print_box( 'Input Error', $text );

  }

}

#############################################################
##
##  draw_page()
##
#############################################################

sub draw_page {

  start_box( 'Changing your Password' );
  print_text( 'If you want to change your password here at radlohead then just stick ' .
              'your details in the form below and click ' );
  print_submit( 'CHANGE' );

  start_form( '13.pl' );
  hidden_field( 'todo', 'change' );
  text_field( 'username' );
  password_field( 'password' );
  password_field( 'new password', 'new_pass1' );
  password_field( 're-type new password', 'new_pass2' );
  end_form( 'CHANGE' );

  end_box();

}

#############################################################