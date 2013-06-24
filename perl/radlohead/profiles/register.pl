###############################################################################################
###############################################################################################
###############################################################################################
##
##  06.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'd:/sites/radlohead/';
#use constant BASE => 'f:/newmind/radiohead/';
use constant RESERVED_NAMES_FILE => BASE . 'files/reserved.nfo';
use constant EMAIL_RECOV_FILE => BASE . 'files/email_recovery.nfo';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle;
use Request;

###############################################################################################

require 'profiles.lib';
require 'forms.lib';
require 'output.lib';

###############################################################################################

my $q = new Request;
my $username = $q->param('username');
trim($username);

###############################################################################################

header( 'Register', get_menu() );

###############################################################################################
##
##  ATTEMPT REGISTRATION
##
###############################################################################################

if ($q->param('todo') eq 'register') {
  if (userExists($username)) {

    ##
    ##  USERNAME IS ALREADY
    ##  REGISTERED
    ##

    print_box( 'Username Taken', qq{

<p>
Sorry, but the username @{[ user_html( $username ) ]} has already been taken.
</p>

    });
    end_box();

  }
  else {

    if (($q->param('password1') eq $q->param('password2'))
      && ($q->param('password1') ne '')
      && (validUsername($username))
      && ($q->param('email'))
      && (notReservedName($username))) {

      # add user to system
      my ($pass,$color) = ($q->param('password1'), getColor($q->param('color')));
      {
        my $fh = new FileHandle(getUserFile($username),'>>');
        print $fh "$username:#:$pass:#:$color:#:0\n";
        $fh->close();
      }

      # update user log
      my $user_number = inc_counter('users');

      # add email to recovery file...
      {
        my $fh = new FileHandle(EMAIL_RECOV_FILE,'>>');
        print $fh $username . ":#:" . $q->param('email') . ":#:$user_number\n";
        $fh->close();
      }

      ##
      ##  OUTPUT SUCCESS
      ##

      top_menu({
                 'ITEMS' => [
                              ['04.pl?todo=create','create'],
                              ['04.pl?todo=color','color']
                            ]
               }
              );

      print_box( 'Profile Registered', qq{

<p>Success, you have registered the username <span style="color:#$color"><b>$username</b></span> at radlohead.com!</p>

<p>You can now use this username with all our facilities here.  If you
have any problems, like forgetting your password just get in touch with
us and we'll try to help you out.</p>

<p>To create a profile for your new username just click the <b>create</b> button up
on the right there.</p>

      });

    }
    else {

      ##
      ##  PASSWORDS DID MATCH
      ##  OR USERNAME INVALID
      ##

      print_box( 'Input Error', qq{

<p>Sorry, but the registration form you submitted was not valid, this will be
for one of the following reasons.</p>

<p><ul>
<li>You did not complete a field.</li>
<li>The username you entered contained invalid characters</li>
<li>You passwords did not match</li>
<li>You are trying to register an official name</li>
</ul></p>

<p>Please <a href="javascript:history.back(1)">click here</a> to try again.</p>

      });

    }
  }
}

###############################################################################################
##
##  OUTPUT THE REGISTER
##  FORM
##
###############################################################################################

else {

  print <<EOT;

<script language="javascript" type="text/javascript">

function checkForm(regForm) {
  if ( (regForm.username.value == '') ||
       (regForm.password1.value == '') ||
       (regForm.password1.value != regForm.password2.value)
     ) {
    alert('Sorry, but you have not completed the registration form correctly,' +
          ' this could be for one of the following reasons.\\n\\n- You missed ' +
          'out a field\\n- Your passwords did not match \\n\\n Press Ok to try again.');
    return false;
  }
  else { return true; }
}

</script>

EOT

  start_box( 'Registration' );
  print 'To register your username here just fill out the form below and click ';
  print_submit( 'regiSTer' );

  start_form("register.pl","return checkForm(this)");
  hidden_field("todo","register");
  text_field("username","",60,30);
  text_field("email","",60,30);
  password_field("<br />&nbsp;password","password1",60,30);
  password_field("<i>re-type password</i>","password2",60,30);
  select_field("color",\&list_colors,[get_colors()]);
  end_form("REGISTER");
  end_box();

}

footer();

###############################################################################################
##
##  notReservedName(username) : boolean
##
###############################################################################################

sub notReservedName {

  my ($username) = @_;
  trim($username);

  my $officialNames = get_reserved_names();

  foreach my $offName (@$officialNames) {
    if ($username =~ /^$offName$/i) { return 0; }
  }
  return 1;

}

###############################################################################################
##
##  get_reserved_names() : list
##
###############################################################################################


sub get_reserved_names {

  my (@reserved_names);

  my $fh = new FileHandle(RESERVED_NAMES_FILE);
  while(my $reserved_name = <$fh>) {
    chomp($reserved_name);
    push(@reserved_names,$reserved_name);
  }

  return \@reserved_names;

}

###############################################################################################