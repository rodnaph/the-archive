#####################################################################################
#####################################################################################
##
##  comments.pl
##
#####################################################################################
#####################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant COMMENTS_DIR => BASE . 'files/comments/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use Request;
use DirHandle;
use FileHandle qw( getline );
use Dispatch;

#####################################################################################

require 'system.lib';

#####################################################################################

my $q = new Request;
my $d = new Dispatch;

#####################################################################################

$d->load(
         -view_file => \&view_file,
         -default => \&view_dir
        );

$d->execute( $q->param('todo') );

#####################################################################################
##
##  view_file()
##
#####################################################################################

sub view_file {

  print get_header();

  my $file = $q->param('file');
  my $fh = new FileHandle( COMMENTS_DIR . $file );

  while( my $line = $fh->getline() ) {

    my ( $name, $date, $message ) = split( /:#:/, $line );

    print qq{

<table border="1" width="100%">
 <tr>
  <th>$name</th>
  <th align="right">$date</th>
 </tr>
 <tr>
  <td colspan="2">
   $message
  </td>
 </tr>
</table>
<br />

    };
  }

  print '</body></html>';

}

#####################################################################################
##
##  view_dir()
##
#####################################################################################

sub view_dir {

  print get_header();

  my $dh = new DirHandle( COMMENTS_DIR );

  while ( my $file = $dh->read() ) {

    if ( $file !~ /(\.|\.\.)/ ) {

      print qq{

 <a href="comments.pl?todo=view_file|file=@{[ URLEncode($file) ]}">@{[ URLDecode($file) ]}</a><br />

      };
    }

  }

  print '</body></html>';

}

#####################################################################################
##
##  get_header()
##
#####################################################################################

sub get_header {

  return <<EOT;
Content-type: text/html

<html>
<head>
<title>Comments</title>

<link href="Admin.css" rel="stylesheet" type="text/css" />

</head>

<body>

<h2>Comments</h2>


EOT

}

#####################################################################################
#####################################################################################