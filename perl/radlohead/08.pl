#####################################################################
#####################################################################
##
##  08.pl
##
#####################################################################
#####################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant BDAY_DIR => BASE . "files/birthdays/";
use constant LIB => BASE . 'lib';
use lib ( LIB );

use Request;

#####################################################################

require 'output.lib';

#####################################################################

my $q = new Request();

#####################################################################

header("Birthdays", '','', 'Birthdays' );
open_tr();

if ($q->param("todo") eq "do_add") { addBirthday($q->param("theDay"),$q->param("theMonth"),$q->param("name")); }
elsif ($q->param("todo") eq "view") { viewMonth($q->param("month"),$q->param("index"),$q->param("days")); }
elsif ($q->param("todo") eq "add") { addBirthdayForm(); }
elsif ($q->param("todo") eq "delete") { delete_birthday_form(); }
elsif ($q->param("todo") eq "do_delete") { delete_birthday(); }
else { draw_page(); }

##################################################
##
##  draw_page
##
##################################################

sub draw_page {

  if (my @todays = get_todays_birthdays()) {

    start_box( 'Todays Birthdays', 'TodaysBirthdays' );

    foreach my $username (@todays) {

      print_user($username);
      print_text("<br>");

    }

    end_box();

  }

  my $text = <<EOT;
<p>This part of radlohead is our birthday calender and contains many of the birthdays for people
who have profiles here.  Just click on the months in the menu above to see who's birthday is
when, or use the add and delete buttons in the top right to add or delete your birthday from
the system.</p>

<p>There have been some renovations going on in this section over the last few days, we hope it
looks and feels better for it.  It used to be that anyone could ad birthdays for anyone, we hoped
that would work out better as some people may be reluctant to put up their own birthdays, but
unfortunately people fucked around with it a little too much and we recieved some complaints.
So a password system has been installed and now only the user can add their birthday.</p>

<p>Though the system is not updated, the old information is still there, so if there are any
mistakes please just tell us about them and we'll sort them out.</p>

EOT

  print_box( 'Birthday Calender', $text );

}

footer();

##################################################
##
##  get_todays_birthdays() : list
##
##  RETURNS USERNAMES OF
##  BIRTHDAYS TODAY
##
##################################################

sub get_todays_birthdays {

  my @date = gmtime(time);
  my ($day,$month) = splice(@date,3,2);

  my (@todays_birthdays);

  $month++;

  dbmopen my %db, BDAY_DIR . $month, 0666;
  foreach my $key (keys %db) {
    if ($key && ($db{$key} eq $day)) {
      push( @todays_birthdays, getUsername($key) );
    }
  }

  return @todays_birthdays;

}

##################################################
##
##  delete_birthday_form()
##
##################################################

sub delete_birthday_form {

  start_box( 'Deleting a Birthday' );
  print_text("To remove your birthday from the system just enter your <b>username</b> " .
             "and <b>password</b> into the form below and click ");
  print_submit("DELETE");

  start_form("08.pl");
  hidden_field("todo","do_delete");
  text_field("username");
  password_field("password");
  end_form("DELETE");
  end_box();

}

##################################################
##
##  delete_birthday()
##
##################################################

sub delete_birthday {

  if (validUser($q->param("username"),$q->param("password"))) {

    ##
    ##  try to delete birthday
    ##

    my $deleted = 0;

    for (my $i=1; $i<13; $i++) {
      dbmopen my %db, BDAY_DIR . $i, 0666;
      if (defined($db{uc($q->param("username"))})) {
        delete $db{uc($q->param("username"))};
        $deleted = 1;
      }
      dbmclose %db;
    }

    if ($deleted) {

      ##
      ##  birthday deleted
      ##

      start_box( 'Birthday Deleted' );
      print_text("Success, the birthday for ");
      print_user($q->param("username"));
      print_text(" has been deleted.");
      end_box();

    } else {

      ##
      ##  birthday not found for that username
      ##

      start_box( 'Birthday Not Found' );
      print_text("Sorry, but there is no birthday for ");
      print_user($q->param("username"));
      print_text(" stored on the system.");
      end_box();

    }

  ##
  ##  input error
  ##

  } else {

    start_box( 'Input Error' );
    print_text("Sorry, but you entered an invalid username/password combination");
    end_box();

  }

}

##################################################
##
##  addBirthday(monthDay, month, username)
##
##  ADDS A BIRTHDAY TO
##  THE FILE
##
##################################################

sub addBirthday {

  my ($day,$month,$username) = @_;
  trim($username);

  if (validUser($username,$q->param("password"))) {

    ##
    ##  remove any other occurances
    ##

    for (my $i=1; $i<13; $i++) {
      dbmopen my %db, BDAY_DIR . $i, 0666;
      undef($db{$username});
      dbmclose %db;
    }

    ##
    ##  add the new user birthday
    ##

    dbmopen my %db, BDAY_DIR . $month, 0666;
    $db{uc($username)} = $day;
    dbmclose %db;

    ##
    ##  output success
    ##

    start_box( 'Birthday added' );
    print_user($username);
    print_text("'s birthday has been added.");
    end_box();

  } else {

    ##
    ##  USER NOT ON SYSTEM
    ##

    start_box( 'Input Error' );
    print_text("Sorry, but the username <b>$username</b> is not " .
               "registered on the system, please try again.");
    end_box();

  }
}

##################################################
##
##  viewMonth(month,index,days)
##
##  OUTPUTS BIRTHDAYS FOR
##  A GIVEN MONTH
##
##################################################

sub viewMonth {

  my ($month,$index,$days) = @_;
  my (@birthdays);

  if ($days gt "31") { $days = 31; }

  ##
  ##  LOAD LIST
  ##

  dbmopen my %db, BDAY_DIR . $index, 0666;
  undef($db{'AULIKKI'});
  foreach my $key (keys %db) {
    push(@birthdays,$db{$key} . ":#:" . getUsername($key));
  }
  dbmclose %db;

  ##
  ##  DRAW MONTH
  ##

  heading($month);
  print_html("<table width=\"100%\">");

  my $j = 0;

  while($j++<6) {
    print_html("<tr>",2);
    my $i = ($j-1) * 5;
    while(($i++<($j*5)) && ($i < ($days+1))) {
      draw_birthdays($i,\@birthdays);
    }
    print_html("</tr>",2);
  }

  $j = 30;
  print_html("<tr>",2);
  while($j++<$days) {
    draw_birthdays($j,\@birthdays);
  }
  print_html("<td colspan=\"" . (36 - $j) . "\">\n</td>",4);
  print_html("</tr>",2);
  print_html("</table>");

}

##################################################
##
##  draw_birthdays(day,ra_birthdays)
##
##################################################

sub draw_birthdays {

  my ($day,$ra_birthdays) = @_;

  print_html("<td valign=\"top\" width=\"20%\">",4);
  my $text = <<EOT;
<table width="100%" border="0">
  <tr>
    <td bgcolor="#FF0000">

      <b>&nbsp;$day</b>

    </td>
  </tr>
  <tr>
    <td class="bordered" valign="top">
EOT

  print_html($text,6);

  ##
  ##  add usernames
  ##

  foreach my $birthday_info (@$ra_birthdays) {
    if (($birthday_info =~ /^$day:#:/) && ($birthday_info != /:#:$/)) {
      my ($day,$username) = split(/:#:/,$birthday_info);

      print_user($username,12);
      print_html("<br />",12);

    }
  }

  print_html("&nbsp;\n      </td>\n    </tr>\n  </table>\n</td>",4);

}

##################################################
##
##  addBirthdayForm()
##
##  DRAWS THE FORM TO
##  ADD A BIRTHDAY
##
##################################################

sub addBirthdayForm {

#  seperator();

  my $text = <<EOT;

<p>To add a birthday to the system, just fill out the form below
then click <b>ADD BIRTHDAY</b>.</p>

EOT

  start_box( 'Adding a Birthday' );
  print_text($text);

  start_form("08.pl");
  hidden_field("todo","do_add");
  text_field("username","name",60,30);
  password_field("password","password",60,30);

  print <<EOT;
  <tr>
    <td align="right">
EOT

  print_text("<b>day</b>");

  print <<EOT;
    </td>
    <td>

      <select name="theDay">
EOT

  for (my $i=1; $i<32; $i++) {
    print("        <option>$i</option>\n");
  }

  print <<EOT;
      </select>

    </td>
  </tr>
  <tr>
    <td align="right">
EOT

  print_text("<b>month</b>");

  print <<EOT;
    </td>
    <td>

      <select name="theMonth">
        <option value="1">January</option>
        <option value="2">February</option>
        <option value="3">March</option>
        <option value="4">April</option>
        <option value="5">May</option>
        <option value="6">June</option>
        <option value="7">July</option>
        <option value="8">August</option>
        <option value="9">September</option>
        <option value="10">October</option>
        <option value="11">November</option>
        <option value="12">December</option>
      </select>

    </td>
  </tr>

EOT

  end_form("ADD BIRTHDAY");
  end_box();

}

##################################################