###############################################################################################
###############################################################################################
##
##  nocache.pl
##
###############################################################################################
###############################################################################################

use strict;

use LWP::Simple;
use CGI;

###############################################################################################

my $q = new CGI();
my $server = 'www.radiohead.com';

###############################################################################################

print $q->header( -type => 'text/html' );

my $header = qq{

<body text="000000" link="000000" alink="000000" leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" marginheight="0" marginwidth="0">

<!-- start nav bar -->

<table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td bgcolor="#eeeeee">

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr>
    <td><nobr style="font-size:8pt;font-family:arial;">
    &nbsp;

     <b><a href="/Profiles" style="text-decoration:none;">Profiles</a></b> |
     <b><a href="/Birthdays" style="text-decoration:none;">Birthdays</a></b> |
     <b><a href="/Images" style="text-decoration:none;">Images</a></b> |
     <b><a href="/Nodes" style="text-decoration:none;">Nodes</a></b> |
     <b><a href="/Msgboard" style="text-decoration:none;">Msgboard</a></b> |
     <b><a href="/Webring" style="text-decoration:none;">Webring</a></b> |
     <b><a href="/Mailbox" style="text-decoration:none;">Mailbox</a></b>
    
    &nbsp; &nbsp;
    </nobr></td>
   </tr></table>

  </td>
  <td><img src="/Data/Images/top_divide.gif" height="20" width="20" /></td>
  <td align="right">

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr>
    <td><b style="font-size:8pt;font-family:arial;"><a href="/" style="text-decoration:none;">radlohead.com&#153;</a> &nbsp; </b></td>
   </tr></table>

  </td>
 </tr>
 <tr>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
  <td></td>
  <td></td>
 </tr>
</table>

<table width="100%" cellpadding="10"><tr><td>

};

my $footer = qq{

</td></tr></table>


<br />

<table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr>
  <td></td>
  <td></td>
  <td bgcolor="#000000"><img src="/Data/Images/spacer.gif" width="1" height="1" alt="" /></td>
 </tr>
 <tr>
  <td>
   &nbsp; &nbsp;
   <b style="font-size:8pt;font-family:arial;"><a style="text-decoration:none;" href="http://www.ill-odium.co.uk" target="_blank">ill-odium product</a></b>
  </td>
  <td width="20"><img src="/Data/Images/bottom_divide.gif" height="20" width="20" /></td>
  <td bgcolor="#eeeeee" align="right">

   <table width="100%" cellpadding="3" cellspacing="0" border="0"><tr><td align="right">
    <nobr style="font-size:8pt;font-family:arial;">
    &nbsp;

    <b><a href="/Msgboard/Coding.asp" style="text-decoration:none;">Code Help</a></b> |
    <b><a href="/Feedback/Contact.asp" style="text-decoration:none;">Contact</a></b> |
    <b><a href="/Admin" style="text-decoration:none;">Admin</a></b>
   </b>
    
    &nbsp; &nbsp;
    </nobr>
   </td></tr></table>

  </td>

 </tr>
</table>

</body>
</html>

};

###############################################################################################
##
##  show a particular post...
##
###############################################################################################

if ( my $number = $q->param('post') ) {

  my $url = "http://$server/msgboard/messages/$number.html";
  my $post = get( $url );

  if ( $post ) {

    my $page = get_page();

    # main shtuff
    $post =~ s/href="(\d+).html"/href="NoCache.pl?post=$1&page=$page"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/help.html"/href="\/Msgboard\/Coding.asp"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/msgboard1.html"/href="NoCache.pl?page=$page"/g;
    $post =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="NoCache.pl?post=$1&page=$page"/g;
    $post =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="Post.pl"/;
    $post = link_names( $post );

    # do html bit...
    $post =~ s/\{link\}(.*)\{\/link\}/<a href="$1">$1<\/a>/gi;
    $post =~ s/\{img\}(.*)\{\/img\}/<img src="$1" \/>/gi;

    print $header . $post . $footer;

  }
  else {

    print_box('Board Error', "Post $number not found at $url" );

  }

}

###############################################################################################
##
##  else draw the main page...
##
###############################################################################################

else {

  my $page = get_page();
  my $url = "http://$server/msgboard/msgboard$page.html";
  my $board = get( $url );

  if ( $board ) {

    $board =~ s/href="http:\/\/$server\/cgi\/msgboard\/security.pl/href="\/Profiles\/Register.asp/;
    $board =~ s/href="msgboard(\d+).html"/href="NoCache.pl?page=$1"/g;
    $board =~ s/href="http:\/\/$server\/msgboard\/messages\/(\d+)\.html"/href="NoCache.pl?post=$1&page=$page"/g;
    $board =~ s/action="http:\/\/$server\/cgi\/msgboard\/msgboard.pl"/action="Post.pl"/;
    $board =~ s/help\.html/\/Msgboard\/Coding.asp/;
    $board = link_names( $board );

    print $header . $board . $footer;

  }
  else {

    print_box('Board Error', "Message Board Page $page not found at $url");

  }

}

###############################################################################################
##
##  link_names( text )
##
###############################################################################################

sub link_names {

  my ( $text ) = @_;

#  $text =~ s/(">)(.*)(<\/font><\/b>)/$1<a href="\/Profiles\/ShowProfile.asp?user=$2">$2<\/a>$3/g;

  return $text;

}

###############################################################################################
##
##  get_page()
##
###############################################################################################

sub get_page {

  return ($q->param('page')) ? $q->param('page') : 1;

}

###############################################################################################
###############################################################################################