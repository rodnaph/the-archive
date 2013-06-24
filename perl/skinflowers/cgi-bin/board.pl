#!/usr/bin/perl

###############################################################################################
###############################################################################################
##
##  board.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BOARD_DIR => '../www/msgboard/';
use constant POSTS_FILE => BOARD_DIR . 'files/posts.nfo';
use constant INFO_FILE => BOARD_DIR . 'files/info.nfo';
use constant TEMP_FILE => BOARD_DIR . 'files/temp.tmp';
use constant BOARD_FILE => BOARD_DIR . 'msgboard.html';
use constant FCNTL_LOCK_FILE => BOARD_DIR . 'files/lock.txt';

use constant FLOOD_DELAY => 15;
use constant MAX_POSTS => 1000;
use constant MAX_THREADS => 40;

use FileHandle qw( print getline );
use File::Copy qw( cp mv );
use CGI;

###############################################################################################

require 'lib/conc.lib';

###############################################################################################

my $q = new CGI;

my $back_up;
my $name = $q->param('name');
my $title = $q->param('title');
my $message = $q->param('message');

my $thread = $q->param('thread');
my $reply = $q->param('reply');

$reply = -1 unless $reply;
$message =~ s/\n/<br \/>/g;

#  remove html...
$name =~ s/[<>]//g;
$title =~ s/[<>]//g;

###############################################################################################

$SIG{__DIE__} = \&error;
error_check();

#  get lock...
my $fh_safe = new FileHandle( FCNTL_LOCK_FILE );
lock_file( $fh_safe );

#  run board...
my $posts_no = get_posts_no();

add_post();
draw_pages();
user_output();

#  release lock...
unlock_file( $fh_safe );

###############################################################################################
##
##  add_post()
##
###############################################################################################

sub add_post {

  if ( $reply == -1 ) {
    $thread = $posts_no;
    $reply = $thread;
    $back_up = '../msgboard';
  } else {
    $back_up = $reply;
  }

  add_post_to_file();
  create_new_post();

  if ($reply != $posts_no) { find_and_update_thread(); }

}

###############################################################################################
##
##  create_new_post()
##
###############################################################################################

sub create_new_post {

  my $date = gmtime( time );

  my $fh = new FileHandle( BOARD_DIR . "posts/$posts_no.html", ">" );

  $fh->print( get_header() );

  print $fh <<EOT;

<p>[ <a href="/msgboard/msgboard.html">top</a> | <a href="/msgboard/posts/$back_up.html">back up</a> ]</p>

<p>posted on $date</p>

<p><b><font size="2">$title</font></b> - <b>$name</b></p>

<blockquote>

  <p>$message</p>

</blockquote>

<!--REPLIES-->

EOT

  add_form( $fh, $reply, $thread );

  $fh->close();

}

###############################################################################################
##
##  add_post_to_file()
##
###############################################################################################

sub add_post_to_file {

  {
    my $fh_posts = new FileHandle( POSTS_FILE );
    my $fh_temp = new FileHandle( TEMP_FILE, '>' );
  
    my $new_thread = qq{<!--$posts_no--><ul><li><a href="posts/$posts_no.html">$title</a> - <b>$name</b></li><!--$posts_no--></ul><!--$posts_no END-->};

    #  if new thread...
    if ( $reply == $posts_no ) {
      $fh_temp->print( "$new_thread\n" );
      while( my $old_thread = $fh_posts->getline() ) { $fh_temp->print( $old_thread ); }
    }

    #  else find position in posts...
    else {
      while( my $a_thread = $fh_posts->getline() ) {
        if ( $a_thread =~ /^<!--$thread-->/ ) {
          $a_thread =~ s/(^.*<!--$reply-->.*<\/li><!--$reply-->)(.*)/$1$new_thread$2/;
          $fh_temp->print( $a_thread );
        }
        else { $fh_temp->print( $a_thread );}
      }
    }

  }

  cp( TEMP_FILE, POSTS_FILE );

}

###############################################################################################
##
##  update_thread(whole_thread,post)
##
###############################################################################################

sub update_thread {

  my ( $whole_thread, $post ) = @_;

  {

    my $fh_post = new FileHandle( BOARD_DIR . "posts/$post.html" ); 
    my $fh_temp = new FileHandle( TEMP_FILE, '>' );

    my $found = 0;

    while( !$found ) {
      my $line = $fh_post->getline();
      if ( $line =~ /^<!--REPLIES-->/ ) {

        $whole_thread =~ s/href="posts\/(\d+)/href="$1/g;
        $whole_thread =~ s/.*(<!--$post-->.*<!--$post END-->).*/$1/;

        my $reply_title = ($whole_thread =~ /^<!--\d+--><\/ul><!--\d+ END-->$/) ? '' : '<b>REPLIES:</b>';
        $whole_thread =~ s/<\/ul><!--(\d+) END--><!--(\d+)--><ul>/<ul><\/ul><!--$1 END--><!--$2-->/g;
        $fh_temp->print( "<!--REPLIES-->$reply_title\n" . $whole_thread . "\n" );

        $found = 1;
      }
      else {
        $fh_temp->print( $line );
      }
    }

    add_form( $fh_temp, $post, $thread );

  }

  cp( TEMP_FILE, BOARD_DIR . "posts/$post.html" ); 

}

###############################################################################################
##
##  find_and_update_thread()
##
###############################################################################################

sub find_and_update_thread {

  my $fh = new FileHandle( POSTS_FILE );

  while( my $thread_text = $fh->getline() ) {
    if ( $thread_text =~ /^<!--$thread-->/ ) {

      $thread_text =~ s/<!--(\d+) END-->/ update_thread($thread_text,$1) /ge;
      last;

    }
  }

  $fh->close();

}

###############################################################################################
##
##  draw_pages()
##
###############################################################################################

sub draw_pages {

  {

    my $fh_posts = new FileHandle( POSTS_FILE );
    my $fh_temp = new FileHandle( TEMP_FILE, '>' );
    my $fh_board = new FileHandle( BOARD_FILE, '>' );

    $fh_board->print( get_header() );

    print $fh_board <<EOT;
<p>
[ <a href="ftp://skinflowers:12345678\@skinflowers.netfirms.com/www/" target="_blank">filespace</a> |
<a href="http://www.skinflowers.org/mp3/punkelvisstream.pls" target="_blank">radio</a> |
<a href="http://www.skinflowers.org/" target="_top">www.skinflowers.org</a> |
<a href="javascript:self.location.reload()">refresh</a> |
<a href="/cgi-bin/nocache.pl">nocache</a> |
<a href="#post">post</a> ]
</p>

<p><ul>

EOT

    for ( my $i=1; $i<=MAX_THREADS; $i++ ) {

      my $thread = $fh_posts->getline();
      $fh_temp->print( $thread );
      $thread =~ s/(<!--\d+-->)<ul>(.*)<\/ul>(<!--\d+ END-->)/$1$2<ul><\/ul>$3/;
      $fh_board->print( $thread );

    }

    $fh_board->print( '</ul></p>' );
    add_form( $fh_board );

  }

  cp( TEMP_FILE, POSTS_FILE );

}

###############################################################################################
##
##  get_header() : html
##
###############################################################################################

sub get_header {

  return <<EOT;
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>SKINFLOWERS</title>

<link href="/msgboard/default.css" rel="stylesheet" />

</head>

<body>

<h1>SKINFLOWERS</h1>

EOT

}

###############################################################################################
##
##  add_form(FileHandle,reply,thread)
##
###############################################################################################

sub add_form {

  my ( $fh, $reply, $thread ) = @_;

  my $type = "MESSAGE";

  if ( $reply ) { $type = "REPLY"; }

  print $fh <<EOT;

<p>
  <a name="post"></a>
  <br />
  <span style="font-size:10pt; font-weight:bold;">POST A $type</span>
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

<form method="post" onsubmit="return checkPost(this,'name','title','message')" action="//www.skinflowers.org/cgi-bin/board.pl">

  <input type="hidden" name="thread" value="$thread" />
  <input type="hidden" name="reply" value="$reply" />

  <b style="font-weight:normal;">NAME:</b><br />
  <input type="text" name="name" value="" size="58" maxlength="60" tabindex="1" />

  <br />

  <b style="font-weight:normal;">TITLE:</b><br />
  <input type="text" name="title" value="" size="58" maxlength="60" tabindex="2" />

  <br />
  <b style="font-weight:normal;">MESSAGE:</b><br />
  <textarea name="message" cols="57" rows="15" tabindex="3" ></textarea>

  <br /><br />

  <input type="submit" value="POST" tabindex="4" />

</form>

</body>
</html>
EOT

}

###############################################################################################
##
##  user_output()
##
###############################################################################################

sub user_output {

  my $board_link = ($q->param('nocache')) ? '/cgi-bin/nocache.pl' : '/msgboard/msgboard.html';
  my $post_link = ($q->param('nocache')) ? '/cgi-bin/nocache.pl?post=' . $posts_no : '/msgboard/posts/' . $posts_no . '.html';
  my $cookie = $q->cookie( -name => 'last_post',
                           -expires => '+1y',
                           -path => '/',
                           -value => time() );

  print $q->header( -type => 'text/html', -cookie => $cookie );
  print get_header();

  print <<EOT;

<p>[ <a href="$board_link">board</a> | <a href="$post_link">your post</a> ]</p>

<p><b>$name</b>, your message titled "$title" has been posted.</p>

</body>
</html>
EOT

}

###############################################################################################
##
##  get_posts_no() : posts_no
##
###############################################################################################

sub get_posts_no {

  my $fh = new FileHandle( INFO_FILE );
  my $posts_no = $fh->getline();

  $fh->close();
  $posts_no = 1 unless $posts_no < MAX_POSTS;
  $fh->open( INFO_FILE, '>' );
  $fh->print( $posts_no + 1 );

  return $posts_no;

}

###############################################################################################
##
##  error_check()
##
###############################################################################################

sub error_check {

  # check required fields are present
  foreach my $field (qw( name title message )) {
    error( 'Fields missing, you must fill in <b>' . $field . '</b>' )
      unless ( $q->param($field) );
  }

  # check for flooding
  if ( my $last_post = time() - $q->cookie('last_post') ) {
    if ( $last_post < FLOOD_DELAY ) {
      error( 'Flooding, you must leave ' . FLOOD_DELAY . ' second(s) between posts.' );
    }
  }

}

###############################################################################################
##
##  error( message )
##
###############################################################################################

sub error {

  my ( $message ) = @_;

  print $q->header( -type => 'text/html' );
  print get_header();
  print <<EOT;

<p>[ <a href="javascript:history.back(1)">back</a> | <a href="/msgboard/msgboard.html">board</a> ]</p>

<p>Sorry, but there was an error posting your message.  The error was reported as:</p>

<blockquote><code>$message</code></blockquote>

<p>You can click the <b>back</b> button above to try again.</p>

</body>
</html>
EOT

  exit();

}

###############################################################################################
###############################################################################################