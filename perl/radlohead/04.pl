###############################################################################################
###############################################################################################
##
##  04.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'd:/sites/radlohead/Archive/2002/';
use constant EDITED_FILE => BASE . 'files/edited_profiles.txt';
use constant TEMP_DIR => BASE . 'files/temp/';
use constant GUIDE_BY => 'the oubliette';
use constant GUIDE_TOP => BASE . 'admin/ProfilesGuide/toptext.txt';
use constant GUIDE_BOTTOM => BASE . 'admin/ProfilesGuide/bottomtext.txt';
use constant GUIDE_PROFILES => BASE . 'admin/ProfilesGuide/profiles.txt';
use constant LIB => BASE . 'lib/';
use lib ( LIB );

use FileHandle qw( print getline );
use Request;
use Dispatch;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request();
my $username = $q->param('username');

trim($username);

my $dispatch = new Dispatch();

$dispatch->load(
                  -create => \&create_profile,
                  -apply => \&apply_changes,
                  -edit => \&edit_profile,
                  -list => \&list_profiles,
                  -color => \&color_form,
                  -changeColor => \&change_color
               );

header( 'Profiles', '','', 'Profiles' );

# dispatching
$dispatch->execute( $q->param('todo') );

footer();

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  my ( $topText, $bottomText ) = ();

  {

    local $/ = undef;
    my $fh = new FileHandle( GUIDE_TOP );
    $topText = $fh->getline();
    $fh->close();
    $fh->open( GUIDE_BOTTOM );
    $bottomText = $fh->getline();

  }

  open_tr();

  print_box( 'Profiles', qq{

<p>
Ok, the profiles stored here are what this site is really about, so you should really go look
at some of them.
</p>

<p>
Their arranged in alphabetical order in 3 categories (a-i,j-r and s-rest).  If you look above
and to your left you can see the links to these pages, just click on them and go, it's pretty
simple really.  Or, you can use the form below to select which profiles you want to view.
</p>

  });

  start_box( 'Viewing Profiles' );
  start_form( '04.pl', '', 'get' );
  hidden_field( 'todo', 'list' );
  select_field( 'from', \&list_alphabet, ['A'], 'From' );
  select_field( 'to', \&list_alphabet, ['I'] );
  end_form( 'VIEW PROFILES' );

  print 'Or to just view a single letter...';

  start_form( '04.pl', '', 'get' );
  hidden_field( 'todo', 'list' );
  select_field( 'from', \&list_alphabet, [], 'View Letter', 'viewLetter(this.form.from)' );
  end_form();

  print 'Or if you know the username you want to view enter it in the field below and click';
  print_submit( 'view profile' );

  start_form( '07.pl', '', 'get' );
  text_field( 'username', 'profile' );
  end_form( 'VIEW PROFILE' );
  end_box();

  print_box( 'Registering and Creating', qq{

<p>If you want to register a new profile, just click on the register button above and to the
right, you'll be asked a little information but nothing to be scared of.  when you have registered
your username you can create a profile for it, just click on the create button and fill out
the form, easy.</p>

<p>When you have created your profile it's your job to take care of it, keep it up to date.  You
can use HTML in your profiles if you want to make them look better, but if you screw it up and
need some help, just ask us, we're only too glad to lend a hand.</p>

  });

  start_box( '<a name="ProfilesGuide"></a>Profiles Guide by ' . user_html(GUIDE_BY), 'ProfilesGuide' );

  print_text($topText);

  my $fh = new FileHandle( GUIDE_PROFILES );
  while( my $profile = $fh->getline() ) {
    chomp( $profile );
    if ( $profile ) {
      my ( $name, $text ) = split( /:#:/, $profile );

      print qq{

<br /><br />

@{[ user_html($name) ]} <br />

<i>$text</i>

      };

    }
  }

  print "<p>$bottomText</p>";
  end_box();

}

###############################################################################################
##
##  change_color()
##
###############################################################################################

sub change_color {

  my ($username,$password,$color) = ($q->param("username"),$q->param("password"),$q->param("color"));

  if (validUser($username,$password)) {

    my ($newColor,$encName) = (getColor($color), URLEncode($username));

    ##
    ##  CHANGE COLOR
    ##

    changeUserColor($username,$password,$newColor);

    ##
    ##  OUTPUT
    ##

    open_tr();
    start_box("Color Changed");
    print_text(user_html($username) . ", your color has been changed to <b><font color=\"#$newColor\">$color</font></b>.");
    end_box();

  } else {

    ##
    ##  INVALID USER
    ##

    my $text = <<EOT;

<p>Sorry, but you did not enter a valid username/password combination.</p>

<p>Please <a href="javascript:history.back(1)">click here</a> to try again.</p>

EOT

    open_tr();
    print_box( "Input Error", $text);

  }
}

###############################################################################################
##
##  colorForm()
##
##  DRAWS THE FORM USED
##  TO CHANGE COLORS
##
###############################################################################################

sub color_form {

  open_tr();
  start_box("Changing Colors");
  print_text("To change your color just enter in your username and password, select your" .
             "new color, then click ");
  print_submit("CHANGE COLOR");


  start_form("04.pl");
  hidden_field("todo","changeColor");
  text_field("username","username");
  password_field("password","password");

  select_field("color",\&list_colors,[get_colors()]);

  end_form("CHANGE COLOR");
  end_box();

}

###############################################################################################
##
##  applyChanges()
##
##  APPLIES CHANGES TO
##  A PROFILE
##
###############################################################################################

sub apply_changes {

  my $vars = $q->Vars();
  $vars->{'stuff'} =~ s/\n/<br \/>/g;

  if (validUser($vars->{'username'},$vars->{'password'})) {

    ##
    ##  WRITE CHANGES
    ##

    {
      my $fh = new FileHandle(getProfilename($vars->{'username'}), ">");

      foreach my $key (get_file_order()) {
        print $fh $vars->{$key} . "\n";
      }
    }

    add_to_edited($vars->{'username'});

    set_has_image($username,valid_image($vars->{'image'}));

    ##
    ##  OUTPUT SUCCESS
    ##

    open_tr();
    start_box("Profile Saved");
    print_text(user_html($vars->{'username'}) . ", your profile has been edited and saved successfully.");
    end_box();

  }

  ##
  ##  INVALID USER
  ##

  else {

    my $text = <<EOT;

<p>Sorry, but you did not enter a valid username/password combination.  This could
be because you either entered the password for <b>$username</b> incorrectly, or that
username does not exist.</p>

<p>Please <a href="javascript:history.back(1)">click here</a> to try again.</p>

EOT

    open_tr();
    print_box("Input Error", $text);

  }
}

###############################################################################################
##
##  editProfile()
##
##  EDITS A PROFILE
##
###############################################################################################

sub edit_profile {

  open_tr();
  start_box("Editing a Profile");
  print_user($username);
  print_text("to edit your profile, just edit the information in the form accordingly and then click ");
  print_submit("APPLY");
  print_help("EditProfile");
  profile_form($username);
  end_box();

}

###############################################################################################
##
##  createProfile()
##
##  OUTPUTS FORM FOR
##  CREATING A PROFILE
##
###############################################################################################

sub create_profile {

  my $text = <<EOT;

<p><b><font color="#FF0000">WARNING</font></b> - If you already have a
profile then this will overwrite all the information on it.</p>

EOT

  open_tr();
  start_box("Creating a Profile");
  print_text("To create your profile, just enter your information into the form below and click ");
  print_submit("apply");
  print_help("EditProfile");
  print_text($text);
  profile_form();
  end_box();

}

###############################################################################################
##
##  profileForm(list)
##
##  OUTPUTS THE FORM
##
###############################################################################################

sub profile_form {

  ##
  ##  LOADING VARS
  ##

  my ($username) = @_;

  ##
  ##  IF EDITING A PROFILE
  ##  GET THE OLD INFO
  ##

  my $vars;

  if ($username) {

    my $fh = new FileHandle(getProfilename($username)) or print getProfilename($username);
    foreach my $key (get_file_order()) {
      $vars->{$key} = <$fh>;
      chomp($vars->{$key});
    }

    local $/ = undef;
    $vars->{'stuff'} .= <$fh>;

  }

  ##
  ##  SET URL FIELDS
  ##

  $vars->{'stuff'} =~ s/<br \/>/\n/g;
  if (!$vars->{'image'}) { $vars->{'image'} = "http://"; }
  if (!$vars->{'website'}) { $vars->{'website'} = "http://"; }

  ##
  ##  PRINT FORM
  ##

  start_form("04.pl");
  hidden_field("todo","apply");
  text_field("username","username","","",$username);
  password_field("password","password");

  text_field("<font color=\"#FF0000\">BOARD NAME</font>","board_name","","",$vars->{'board_name'});
  text_field("<font color=\"#FF0000\">REAL NAME</font>","real_name","","",$vars->{'board_name'});
  text_field("<font color=\"#FF0000\">GENDER</font>","gender","",100,$vars->{'gender'});
  text_field("<font color=\"#FF0000\">FROM</font>","from","",100,$vars->{'from'});
  text_field("<font color=\"#FF0000\">DATE OF BIRTH</font>","dob","",100,$vars->{'dob'});
  text_field("e-mail","email","",100,$vars->{'email'});
  text_field("image of you","image","",100,$vars->{'image'});
  text_field("your website","website","",100,$vars->{'website'});
  text_area("<font color=\"#FF0000\">STUFF</font>","stuff",70,10,$vars->{'stuff'});
  end_form("APPLY");

}

###############################################################################################
##
##  listProfiles(from, to)
##
###############################################################################################

sub list_profiles {

  ##
  ##  SET LOCALS
  ##

  my ($from,$to,$actual_to) = ($q->param("from"),$q->param("to"),$q->param("to"));

  if (!$to) { $to = $from; }
  if ($to eq "REST") { $to = "Z"; }
  if ($to lt $from) {
    my $temp = $to;
    $to = $from;
    $from = $temp;
  }

  ##
  ##  draw menu
  ##

  {
    my ($ra_items,$to_url,$from_url);

    $to_url = "|to=$to" unless (ord($from) < ord("B"));
    $from_url = "|to=".uc(chr(ord($to)+1)) unless (ord($to) > ord("Y"));

    if (ord($from) > ord("A")) { push(@$ra_items,["04.pl?todo=list|from=".uc(chr(ord($from)-1)).$to_url,"<"]); }

    for (my $i=ord($from); $i < (ord($to)+1); $i++) {
      my $l = lc(chr($i));
      push(@$ra_items,["#".uc($l),$l]);
    }
    if ($actual_to eq "REST") { push(@$ra_items,["#REST","rest"]); }
    elsif (ord($to) < ord("Z")) { push(@$ra_items,["04.pl?todo=list|from=$from".$from_url,">"]); }


    top_menu({
               "ITEMS" => $ra_items,
               "ALIGN" => "right",
               "NO_BASE" => "true"
             });
  }

  ##
  ##  page heading
  ##

  my $draw_to;
  if ($actual_to) {
    $draw_to = " - $actual_to";
  }

  open_tr();
  heading("profiles $from $draw_to");
  print_text("(<i>italics</i> mean there is no profile,<br />");
  print_text("<img src=\"files/images/site/has_image.gif\" width=\"12\" height=\"12\" alt=\"profile has an image\" /> means there is an image.)");

  ##
  ##  load and draw users
  ##

  my $profiles_drawn_count = 0;

  for (my $i=ord($from); $i < (ord($to)+1); $i++) {

    my @users;

    my $fh = new FileHandle(getUserFile(chr($i)));
    while(my $user = <$fh>) {
      chomp($user);
      if ($user) { push(@users,$user); }
    }
    $fh->close();

    draw_shortcut(chr($i));
    draw_users(\@users,$from,$to,\$profiles_drawn_count);

  }

  ##
  ##  PROFILES THAT START
  ##  WITH NUMBERS
  ##

  if (($actual_to eq "REST") or ($from eq "REST")) {
    draw_shortcut("REST");
    my $fh = new FileHandle(getUserFile("0"));
    while(my $profile = <$fh>) {
      print_html("<br />");
      print_user_data($profile);
      $profiles_drawn_count++;
    }
    $fh->close();
  }

  print_text("<p>(<b>$profiles_drawn_count</b> profiles drawn)</p>");

}

###############################################################################################
##
##  draw_users(ra_users,from,to,rs_profiles_drawn_count)
##
###############################################################################################

sub draw_users {

  my ($ra_users,$from,$to,$rs_profiles_drawn_count) = @_;

  foreach my $user (sort(@$ra_users)) {

    print_html("<br />");
    print_user_data($user);

    $$rs_profiles_drawn_count++;
  }

}

###############################################################################################
##
##  draw_shortcut(link)
##
###############################################################################################

sub draw_shortcut {

  my ($link) = @_;

  print_html("<br /><br /><a name=\"$link\"></a>");

}

###############################################################################################
##
##  add_to_edited($username)
##
###############################################################################################

sub add_to_edited {

  my ($username) = @_;

  if (not_in_edited_file($username)) {

    my $fh = new FileHandle(EDITED_FILE,">>");
    print $fh $username . "\n";
    $fh->close();

  }

}

###############################################################################################
##
##  set_has_image(username,has_image)
##
###############################################################################################

sub set_has_image {

  my ($username,$has_image) = @_;

  my $user_file = getUserFile($username);
  my $temp_file = get_temp("set_has_image");

  {  
    my $fh = new FileHandle($user_file);
    my $fh_temp = new FileHandle($temp_file,">");

    while (my $user = <$fh>) {

      if ($user =~ /^$username:#:/i) {

        my ($username,$password,$color) = split(/:#:/,$user);
        chomp($color);
        print $fh_temp "$username:#:$password:#:$color:#:$has_image\n";

      } else {
        print $fh_temp $user;
      }

    }
  }

  copy_file($temp_file,$user_file);

}

###############################################################################################
##
##  not_in_edited_file(username)
##
###############################################################################################

sub not_in_edited_file {

  my ($username) = @_;

  my $fh = new FileHandle(EDITED_FILE) or return 1;
  while (my $user = <$fh>) {
    chomp($user);
    if ($username =~ /^$user$/i) { return 0; }
  }
  $fh->close();

  return 1;

}

###############################################################################################
