###############################################################################################
###############################################################################################
##
##  upload.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'd:/sites/radlohead/';
#use constant BASE => 'f:/newmind/radiohead/';
use constant UPLOAD_DIR => BASE . 'files/images/profiles/';
use constant BUFFER_SIZE => 16_384;
use constant MAX_FILE_SIZE => 200_000;
use constant LIB => BASE . 'lib';
use lib ( LIB, BASE . 'images/lib' );

use CGI;
use Dispatch;
use FileHandle qw( print );

###############################################################################################

require 'forms.lib';
require 'images_output.lib';

###############################################################################################

$CGI::DISABLE_UPLOADS = 0;
$CGI::POST_MAX = MAX_FILE_SIZE;

$TempFile::TMPDIRECTORY = BASE . 'files/temp';

my $q = new CGI;
my $d = new Dispatch;

###############################################################################################

$d->load(
         -upload => \&upload
        );

$d->execute( $q->param('todo') );

###############################################################################################
##
##  upload()
##
###############################################################################################

sub upload {

  my $error = $q->cgi_error();
  my $file = $q->param('file');
  $q->param('file') =~ /(\.\w+)$/;
  my $ext = $1;
  my $username = $q->param('username');
  my $filename = URLEncode($username) . $ext;
  my $fh = $q->upload( 'file' );
  my $buffer = '';

  if ( $ext !~ /(jpg|jpeg|gif|bmp|png)/i) {
    $error = 1;
  }

  if ( (!$error) && ($file) && (validUser($username,$q->param('password'))) ) {

    my $fh_image = new FileHandle( UPLOAD_DIR . $filename, '>' );

    binmode $fh;
    binmode $fh_image;

    while( read( $fh, $buffer, BUFFER_SIZE ) ) {
      $fh_image->print( $buffer );
    }

    $fh_image->close();

  }
  else {
    $error = 1;
  }

  images_header();

  if ( $error ) {

    ##
    ##  inform user of the error...
    ##

    print_box( 'Upload Error', qq{

<p>
Sorry, there was an error uploading your file, this may be for one of the following
reasons.
</p>

<ul>
 <li>You gave an invalid filename</li>
 <li>Your file is bigger than allowed (200Kb)</li>
 <li>You did not enter a valid username/password</li>
</ul>

<p>
Please try again, or if you continue to have problems contact us <a href="/feedback">here</a>.
</p>

    });
  }
  else {

    ##
    ##  give success output...
    ##

    my $link = 'http://www.radlohead.com/images/show.pl?user=' . URLEncode($filename);

    print_box( 'File Uploaded', qq{

<p>
Success!  @{[ user_html($q->param('username')) ]} your file has been uploaded successfully,
you can access it with the following URL...
</p>

<blockquote>
<a href="$link">$link</a>
</blockquote>

    });

  }

  images_footer();

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  images_header();

  start_box( 'Uploading An Image' );
  print qq{

<p>
If you have an image you want to use on your profile then you can easily upload
it to our space using the form below.  You can then use the URL we'll provide you
with to access that image not only on your profile, but anywhere on the net.
</p>

<p>
<b>NB.</b> Depending on the size of the file you are uploading and the speed
of your connection, this may take some time to complete.  Please be patient.
</p>

  };

  start_form( 'upload.pl', '', '', 'multipart/form-data' );
  hidden_field( 'todo', 'upload' );
  text_field( 'username' );
  password_field( 'password' );
  file_field( 'your image', 'file' );
  end_form( 'UPLOAD' );

  end_box();

  images_footer();

}

###############################################################################################
###############################################################################################