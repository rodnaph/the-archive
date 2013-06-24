#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  board.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => '../www/msgboard/';
use constant DATA_DIR => BASE . 'data/';
use constant POSTS_DIR => BASE . 'posts/';
use constant DATA_POSTS => DATA_DIR . 'posts';
use constant DATA_INFO => DATA_DIR . 'info.dat';
use constant DATA_LOCK => DATA_DIR . 'file.lock';
use constant DATA_LOG => DATA_DIR . 'error.log';

use constant THREADS_PER_PAGE => 40;
use constant MAX_POSTS => 1000;
use constant FLOOD_DELAY => 10;
use constant ERROR_LOG => 1;

use lib ( '../../lib' );
use Skinflowers::Database;
use FileHandle qw( getline print getlines );
use CGI::Carp qw( fatalsToBrowser );
use CGI;
use Fcntl qw( :flock );

###############################################################################################

require 'users.lib';

###############################################################################################

my $q = new CGI;
my @parents = split( /,/, $q->param('parents') );

my $cgi_url = '/cgi-bin';
my $board_url = '/msgboard';
my $page_name = 'msgboard';

###############################################################################################

# catch croak
$SIG{__DIE__} = \&error;

# check for errors
error_check();

# get file lock
my $fh_lock = new FileHandle( DATA_LOCK ) || error( 'Error opening file: ' . DATA_LOCK );
lock_file( $fh_lock );

# do stuff
my $id = get_next_id();
remove_html(qw( name title ));
new_post();
add_post();
draw_pages();

# release lock and output
unlock_file( $fh_lock );
output();

###############################################################################################
##
##  new_post()
##
###############################################################################################

sub new_post {

  my $filename = POSTS_DIR . $id . '.html';
  my $fh = new FileHandle( $filename, '>' ) || error( 'Error opening file: ' . $filename );
  my $parents = ($q->param('parents')) ? $q->param('parents') . ",$id" : $id;
  my $date = gmtime( time() + 3600 );
  my $back_up = (@parents) ? "$parents[$#parents].html" : '../' . $page_name . '.html';
  my $message = $q->param('message');

  $message =~ s/\n/<br \/>/g;

  $fh->print( get_header() );
  $fh->print(qq{

<p><b>@{[ $q->param('title') ]}</b></p>

<p>
[
<a href="../@{[ $page_name ]}.html">main</a> |
<a href="#post">post</a> |
<a href="javascript:location.reload()">refresh</a> |
<a href="$back_up">back up</a> |
<a href="#replies">replies</a>
]
</p>

<p>
  Posted by <b>@{[ $q->param('name') ]}</b> on <i>$date</i>
</p>

<p><blockquote>$message</blockquote></p>

<ul><!--insert: $id--!>
</ul>

  });
  $fh->print( get_form($parents) );
  $fh->print( get_footer() );

}

###############################################################################################
##
##  add_post()
##
###############################################################################################

sub add_post {

  local $/ = undef();

  # get old data
  my $fh = new FileHandle( DATA_POSTS ) || error( 'Error opening file: ' . DATA_POSTS );
  my $thread = qq{ <li><a href="$board_url/posts/$id.html">@{[ $q->param('title') ]}</a> - <b>@{[ $q->param('name') ]}</b></li><ul><!--insert: $id--!></ul> };
  my $posts = $fh->getline();

  # insert new thread
  if ( @parents ) {
    $posts =~ s/(<!--insert: $parents[$#parents]--!>)/$1$thread/;
    thread_posts( $thread );
  }
  else { $posts = $thread . "\n" . $posts; }

  # write data back
  $fh->close();
  $fh->open( DATA_POSTS, '>' );
  $fh->print( $posts );
  $fh->close();

}

###############################################################################################
##
##  thread_posts( thread )
##
###############################################################################################

sub thread_posts {

  my ( $thread ) = @_;

  local $/ = undef();

  # setup parent info
  my ( @parents ) = split( /,/, $q->param('parents') );
  my $parent = $parents[$#parents];

  while ( my $post_num = pop( @parents ) ) {

    # get data from post file
    my $file = POSTS_DIR . $post_num . '.html';
    my $fh = new FileHandle( $file ) || error( 'Error opening file: ' . $file );
    my $data = $fh->getline();
    my $reply = ( $post_num eq $parent ) ? '<p><a name="replies"></a><b>Replies</b></p>' : '';

    # edit data and save
    $data =~ s/(.*)(<ul><!--insert: $parent--!>)/ (($1)?'':$reply) . "$1$2\n\n$thread\n" /e;
    $fh->close();
    $fh->open( $file, '>' );
    $fh->print( $data );
    $fh->close();

  }

}

###############################################################################################
##
##  draw_pages()
##
###############################################################################################

sub draw_pages {

  # get threads from file
  my $fh_posts = new FileHandle( DATA_POSTS ) || error( 'Error opening file: ' . DATA_POSTS );
  my @threads = $fh_posts->getlines();

  # set posts file ready for writing
  $fh_posts->close();
  $fh_posts->open( DATA_POSTS, '>' ) || error( 'Error opening file: ' . DATA_POSTS );

  # open board file and add header
  my $filename = BASE . $page_name . '.html';
  my $fh_board = new FileHandle( $filename, '>' ) || error( 'Error opening file: ' . $filename );

  $fh_board->print( get_header() );
  $fh_board->print(qq{

<p>
[ <a href="ftp://skinflowers:12345678\@skinflowers.netfirms.com/www/" target="_blank">filespace</a> |
<a href="http://www.skinflowers.org/downloads.shtml" target="_top">music</a> |
<a href="http://www.skinflowers.org/" target="_top">www.skinflowers.org</a> |
<a href="javascript:self.location.reload()">refresh</a> |
<a href="/cgi-bin/nocache.pl">nocache</a> |
<a href="#post">post</a> |
<a href="$cgi_url/register.pl">register</a> ]
</p>

  });

  $fh_board->print(qq{

<p><b>Threads</b></p>

<ul>

  });

  # add threads
  for ( my $i=0; ($i<THREADS_PER_PAGE) && (my $thread = shift(@threads)); $i++ ) {

    $fh_board->print( "$thread\n" );
    $fh_posts->print( $thread );

  }

  # add form and footer
  $fh_board->print( '</ul>' );
  $fh_board->print( get_form() );
  $fh_board->print( get_footer() );

}

###############################################################################################
##
##  output()
##
###############################################################################################

sub output {

  my $message = $q->param('message');
  my $date = gmtime( time() );
  my $cookie = $q->cookie( -name => 'last_post',
                           -expires => '+1y',
                           -path => '/',
                           -value => time() );

  $message =~ s/\n/<br \/>/g;

  print $q->header( -type => 'text/html', -cookie => $cookie ),
        get_header(),
        qq{

<p>
  <b>@{[ $q->param('title') ]}</b>
</p>

<p>
[
<a href="$board_url/@{[ $page_name ]}.html">main</a> |
<a href="$board_url/posts/$id.html">your post</a>
]
</p>

<p>
  <b>@{[ $q->param('name') ]}</b>,
  your post with the following message has been posted.
</p>

<p>
 <blockquote>$message</blockquote>
</p>

<p>
 Posted on <i>$date</i>
</p>

        },
        get_footer();

}

###############################################################################################
##
##  get_header()
##
###############################################################################################

sub get_header {

  return qq{
<html>
<head>
<title>SKINFLOWERS</title>

<link href="$board_url/default.css" rel="stylesheet" type="text/css" />

</head>

<body>

<h1>SKINFLOWERS</h1>

  };

}

###############################################################################################
##
##  get_form()
##
###############################################################################################

sub get_form {

  my ( $parents, $name, $title, $message ) = @_;

  return qq{

<p>
  <a name="post"></a>
  <b>Post Message</b>
</p>

<script language="javascript" type="text/javascript">

var errorMessage='Sorry, but you have missed out one of the fields.';

// checkPost(form,arguments...);
function checkPost(form) {
 var valid=true;
 for(var i=1;i<arguments.length;i++){
  eval('if(form.'+arguments[i]+'.value==\\'\\'){valid=false}');
 }
 if(valid)return true;
 else{
  alert(errorMessage);
  return false
 }
}

</script>

<form method="post" onsubmit="return checkPost(this,'name','title','message')" action="$cgi_url/msgboard.pl">

  <input type="hidden" name="parents" value="$parents" />

  <b>Name</b><br />
  <input type="text" name="name" size="58" maxlength="60" value="$name" />

  <br /><b>Password:</b> <i>(only needed for registered names)</i><br />
  <input type="password" name="pass" size="58" maxlength="60" />

  <br /><b>Subject</b><br />
  <input type="text" name="title" size="58" maxlength="60" value="$title" />

  <br /><b>Message</b><br />
  <textarea name="message" cols="50" rows="15">$message</textarea>

  <br /><br />

  <input type="submit" value="Post Message" />
  <input type="reset" value="Reset" />

</form>

  };

}

###############################################################################################
##
##  get_footer()
##
###############################################################################################

sub get_footer {

  return qq{

</body>
</html>

  };

}

###############################################################################################
##
##  get_next_id()
##
###############################################################################################

sub get_next_id {

  my $fh_info = new FileHandle( DATA_INFO ) || error( 'Error opening file: ' . DATA_INFO );
  my $id = $fh_info->getline();

  $id = 1 unless $id < MAX_POSTS;

  $fh_info->close();
  $fh_info->open( DATA_INFO, '>' );
  $fh_info->print( $id + 1 );
  $fh_info->close();

  return $id;

}

###############################################################################################
##
##  remove_html( [, params ] )
##
###############################################################################################

sub remove_html {

  my ( @params ) = @_;

  my %swaps = ( '&' => '&amp;',
                '<' => '&lt;',
                '>' => '&gt;' );

  foreach my $param ( @params ) {

    my $value = $q->param($param);

    foreach my $swap ( keys %swaps ) {
      $value =~ s/$swap/$swaps{$swap}/g;
    }

    $q->param( $param, $value );

  }

}

###############################################################################################
##
##  error_check()
##
###############################################################################################

sub error_check {

  # check parent data is ok
  my $parent_data = $q->param('parents');
  $parent_data =~ s/[0-9,]//g;
  error( 'Parent data corrupted!' ) unless !$parent_data;

  # check for required fields
  foreach my $field (qw( name title message )) {
    error( 'Field missing, you need to give a <b>' . $field . '</b>' )
      unless $q->param($field);
  }

  # check for flooding
  if ( my $last_post = time() - $q->cookie('last_post') ) {
    if ( $last_post < FLOOD_DELAY ) {
      error( 'Flooding, you must leave ' . FLOOD_DELAY . ' second(s) between posts.' );
    }
  }

  # check user is ok
  error( 'Invalid User, that username has been registered and requires a password.' )
    unless valid_user( $q->param('name'), $q->param('pass') );

#   my $db = new Skinflowers::Database( db => 'main', user => 'skinorg', pass => 'bling52' );
#   my $sql = ' SELECT pass FROM users ' .
#             ' WHERE name LIKE ' . $db->quote($q->param('name'));
#   my $res = $db->query( $sql );

#   if ( ($row = $res->getNextRow()) && ($row->{pass} ne $q->param('pass')) ) {
#     error( 'Invalid User, that username requires a valid password' );
#   }

}

###############################################################################################
##
##  error( message, no_log )
##
###############################################################################################

sub error {

  my ( $message, $no_log ) = @_;

  # log error if appropriate
  if ( ERROR_LOG && !$no_log ) {
    my $fh = new FileHandle( DATA_LOG, '>>' ) || error( 'Error opening file: ' . DATA_LOG, 1 );
    my $date = gmtime( time() );

    $fh->print( "[$date] $message\n" );
    $fh->close();
  }

  # give output to user
  print $q->header( -type => 'text/html' ),
        get_header(),
        qq{

<p>
 [
  <a href="$board_url/@{[ $page_name ]}.html">main page</a>
 ]
</p>

<p>Sorry, but there was an error posting your message.  The error was reported as:</p>

<blockquote><code>$message</code></blockquote>

        },
        get_form( $q->param('parents'), $q->param('name'), $q->param('title'), $q->param('message') ),
        get_footer();

  exit();

}

###############################################################################################
##
##  lock_file( fh )
##
###############################################################################################

sub lock_file {

  my ( $fh ) = @_;

  # so eval will die quietly
  my $rs_die = $SIG{__DIE__};
  $SIG{__DIE__} = undef();

  eval {

    my $count = 0;
    my $delay = 1;
    my $max = 15;

    until ( flock( $fh, LOCK_EX ) | LOCK_NB ) {
      exit() if $count >= $max;
      sleep $delay;
      $count += $delay;
    }

  };

  $SIG{__DIE__} = $rs_die;

}

###############################################################################################
##
##  unlock_file( fh )
##
###############################################################################################

sub unlock_file {

  my ( $fh ) = @_;

  # so eval will die quietly
  my $rs_die = $SIG{__DIE__};
  $SIG{__DIE__} = undef();

  eval {

    flock( $fh, LOCK_UN );

  };

  $SIG{__DIE__} = $rs_die;

}

###############################################################################################
###############################################################################################