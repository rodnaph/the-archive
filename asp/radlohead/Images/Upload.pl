###############################################################################################
###############################################################################################
##
##  Upload.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant UPLOAD_DIR => BASE . 'Data/Images/Users/';
use constant BUFFER_SIZE => 16_384;
use constant MAX_FILE_SIZE => 200_000;

use CGI;
use FileHandle qw( print );

###############################################################################################

$CGI::DISABLE_UPLOADS = 0;
$CGI::POST_MAX = MAX_FILE_SIZE;

$TempFile::TMPDIRECTORY = BASE . 'Data/Temp';

my $q = new CGI;

###############################################################################################

upload();

###############################################################################################
##
##  upload()
##
###############################################################################################

sub upload {

  print "Content-type: text/html\n\n";

  my $error = $q->cgi_error();
  my $file = $q->param('filename');
  $q->param('filename') =~ /(\.\w+)$/;
  my $ext = lc($1);
  my $username = $q->param('username');
  my $filename = encode($username) . $ext;
  my $fh = $q->upload( 'file' );
  my $buffer = '';

  if ( $ext !~ /(jpg|jpeg|gif|bmp|png)/i) {
    $error = 1;
  }

  if ( !$error && $file ) {

    my $fh_image = new FileHandle( UPLOAD_DIR . $filename, '>' );
print "nobinmode";
    binmode $fh;
    binmode $fh_image;
print "before";
    while( read( $fh, $buffer, BUFFER_SIZE ) ) {
      $fh_image->print( $buffer );
    }
print "qwe";
    $fh_image->close();
print "done";
  }
  else {
    $error = 1;
  }

  print qq{

<html>
<head>
<title>Image Uploading</title>

<link href="/Data/CSS/Default.css" rel="stylesheet" type="text/css" />

</head>

<body>

<h2>Image Uploading</h2>

  };

  if ( $error ) {

    ##
    ##  inform user of the error...
    ##

    print qq{

<p>
Sorry, there was an error uploading your file, this may be for one of the following
reasons.
</p>

<ul>
 <li>You gave an invalid filename</li>
 <li>Your file is bigger than allowed (200Kb)</li>
</ul>

<p>
Please try again, or if you continue to have problems contact us <a href="/feedback">here</a>.
</p>

    };
  }
  else {
print "else";
    ##
    ##  give success output...
    ##

    my $link = 'http://www.radlohead.com/Images/Show.pl?url=' . encode( 'http://www.radlohead.com/Data/Images/Users/' . $filename );

    print qq{

<p>
Success!  @{[ $q->param('username') ]} your file has been uploaded successfully,
you can access it with the following URL...
</p>

<blockquote>
<a href="$link">$link</a>
</blockquote>

    };

  }

  print qq{

<p align="right">
  <a href="javascript:window.close()">close window</a>
</p>

</body>
</html>

  };

}

###############################################################################################
##
##  encode( text )
##
###############################################################################################

sub encode {

  my $text = shift;

  $text =~ s/([^a-z0-9_.~-])/ sprintf "%%%02X", ord($1)/eig;

  return $text;

}

###############################################################################################
###############################################################################################