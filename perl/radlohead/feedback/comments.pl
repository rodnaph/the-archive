###############################################################################################
###############################################################################################
##
##  comments.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant COMMENTS_DIR => BASE . 'files/comments/';
use constant MAX_COMMENTS => 20;
use constant LIB => BASE . 'lib';
use lib ( LIB );

use Request;
use FileHandle qw( print getline );
use Dispatch;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request();
my $d = new Dispatch();

###############################################################################################

$d->load(
         -view => \&view,
         -leave => \&leave
        );

# dispatching
$d->execute( $q->param('todo') );

###############################################################################################
##
##  view()
##
###############################################################################################

sub view {

  my $for = $q->param('for');
  my $com_file = COMMENTS_DIR . URLEncode($for);
  my $error = 0;

  # add message if needed
  if ( $q->param('add') ) {

    # check for valid user
    if ( validUser($q->param('username'),$q->param('password')) ) {

      my $comments = $q->param('comments');
      my $user = $q->param('username');
      my $date = gmtime( time() );
      my $temp_file = get_temp('leave_comment');

      $comments =~ s/\n/<br \/>/g;

      {
        my $fh = new FileHandle( $com_file );
        my $fh_temp = new FileHandle( $temp_file, '>' );

        $fh_temp->print( "$user:#:$date:#:$comments\n" );

        for ( my $i=1; ($fh) && ($i<MAX_COMMENTS) && (my $comment=$fh->getline()); $i++ ) {
          $fh_temp->print( $comment );
        }
      }

      copy_file( $temp_file, $com_file );

    }
    else {
      $error = 1;
    }

  }

  ##
  ##  draw out comments...
  ##

  header( 'Comments' );
  open_tr();

  if ( $error ) {
    print_box( 'Invalid User', 'Sorry but you are not a valid user, your comment was not added' );
  }
  elsif ( $q->param('add') ) {
    print_box( 'Comment Added', "Thank you for adding your comment about <b>$for</b>, your post " .
                                "should be visible in the list below." );
  }

  my $text = <<EOT;

<p>
Below are the comments which have been left for <b>$for</b>.  If you want to add a comment
of your own to the list then use the links at the end of the posts.
</p>

EOT

  start_box( "Comments for $for", $for );
  print $text;

  my $fh = new FileHandle( $com_file );

  while ( $fh && (my $comment = $fh->getline()) ) {
    my ( $user, $date, $comments ) = split( /:#:/, $comment );
    my $text = <<EOT;

<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr bgcolor="#ff0000"><td>
 <table width="100%" cellpadding="4" cellspacing="2" border="0"><tr bgcolor="#000000">
  <td background="/files/images/site/back.gif"><table width="100%" cellpadding="0" cellspacing="0" border="0">
   <tr>
    <td>
   &nbsp; @{[ user_html($user) ]}
    </td>
    <td align="right" valign="top">
     <b>$date</b> &nbsp;
    </td>
   </tr>
  </table></td></tr>
  <tr bgcolor="#000000">
  <td background="/files/images/site/back.gif">
    <br />
    <blockquote>$comments</blockquote>
  </td>
 </tr></table>
</td></tr></table>

<br />

EOT
    print_text( $text, 6 );
  }

  end_box();

  footer();

}

###############################################################################################
##
##  leave()
##
###############################################################################################

sub leave {

  my $for = $q->param('for');

  my $text = <<EOT;

<p>
You are leaving a comment for/on <b>$for</b>.  The comments system was introduced to firstly
try and get more feedback from what the sites users want/don't want, and secondly
just to allow a more communicative/dynamic site.  So, please, just say whatever you
want.
</p>

<p>
To leave a comment you have to be a registered user of this site.  If you
are not then you can easily go get yourself a username by clicking on the
<b>register</b> option in the profiles menu at the top of the page.
</p>

EOT

  header( 'Comments' );
  open_tr();

  start_box( 'Leaving Your Comment' );
  print_text( $text );

  start_form( 'comments.pl' );
  hidden_field( 'todo', 'view' );
  hidden_field( 'add', 'yes' );
  hidden_field( 'for', $for );
  text_field( 'username' );
  password_field( 'password' );
  text_area( 'comments' );
  end_form( 'LEAVE COMMENTS' );

  end_box();

  footer();

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  use CGI;

  my $q = new CGI;

  print $q->redirect('http://www.radlohead.com');

}

###############################################################################################
###############################################################################################