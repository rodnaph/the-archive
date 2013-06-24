###############################################################################################
###############################################################################################
##
##  quickchat.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => '../../../../'; #ignore yup.
use constant MAX_LINES => 7;
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( print getline );
use CGI;
use Dispatch;

###############################################################################################

require 'quickchat.lib';
require 'system.lib';

###############################################################################################

my $q = new CGI;
my $d = new Dispatch;

###############################################################################################

$d->load(
         -post => \&post_chat_message
        );

$d->execute( $q->param('todo') );

###############################################################################################
##
##  post_chat_message()
##
###############################################################################################

sub post_chat_message {

  my $user = $q->param('chat_name');
  my $line = $q->param('chat_line');

  if ( $user && $line ) {

    my $temp_file = get_temp('quickchat');
    {
      my $fh_chat = new FileHandle( get_chat_file() );
      my $fh_temp = new FileHandle( $temp_file, '>' );

      $fh_temp->print(qq{ &nbsp; &lt;<b><font color="#ff0000">$user</font></b>&gt; $line<br />\n });

      for ( my $i=0; $i<MAX_LINES; $i++ ) {
        $fh_temp->print( $fh_chat->getline() );
      }
    }
    copy_file( $temp_file, get_chat_file() );

  }

  print $q->redirect( $ENV{HTTP_REFERER} );

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  print $q->header( -type => 'text/html' );
  print qq{
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>RADlOHEAD - Quickchat</title>

<link href="//localhost/sites/radlohead/files/css/ie.css" rel="stylesheet" type="text/css" />

<style type="text/css">

A { text-decoration:none; }
.mainMenu { behavior: url(//www.radlohead.com/files/htc/MainMenu.htc); }
P, TD, H2 { font-family:arial,helvetica,verdana; }
T, TD, P { font-size:10pt; }

</style>

</head>

<body bgcolor="#000000" background="/files/images/site/back.gif" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF">

  },
  get_chat_box( 1 ),
  qq{

<p align="right">
[
<a href="javascript:location.reload()">refresh display</a> |
<a href="javascript:self.close()">close quickchat</a>
]
</p>

</body>
</html>

  };

}

###############################################################################################
###############################################################################################
