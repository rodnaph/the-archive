###############################################################################################
###############################################################################################
##
##  14.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle;
use Request;
use Encoding;
use UserManager;
use Profile;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request();
my $um = new UserManager();

###############################################################################################
###############################################################################################

my $url_base = get_url_base();
my $stylesheet = get_stylesheet();
my $username = $q->param('username');
my $image_url = 'http://www.radlohead.com/images/show.pl?url=' . Encoding::encode( get_image_url() );

###############################################################################################
##
##  draw header
##
###############################################################################################

print <<EOT;
Content-type: text/html

<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>RADlOHEAD - $username</title>

<link href="$url_base/files/css/$stylesheet" rel="stylesheet" />

<style type="text/css">

A {text-decoration:none}

</style>

<script language="javascript" type="text/javascript">

function resizeWin() {

  var myimg = new Image();
  myimg.src = '$image_url';

  self.resizeTo(myimg.width+30,myimg.height+90);

}

</script>

</head>

<body bgcolor="#000000" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF" background="$url_base/files/images/site/back.gif" onload="resizeWin()">

 <img src="$image_url" alt="$username" />
 <br />
 <center>
   <font face="arial,helvetica,verdana">
     <a href="javascript:window.close()">close window</a>
   </font>
 </center>

</body>
</html>
EOT

###############################################################################################
##
##  get_image_url() : scalar
##
###############################################################################################

sub get_image_url {

  my $user = $um->user( $username );
  my $profile = $user->get_profile();

  return $profile->image();

}

sub get_image_url2 {

  my $fh = new FileHandle(getProfilename($username));
  my ($vars);

  foreach my $key (get_file_order()) {
    $vars->{$key} = <$fh>;
    chomp($vars->{$key});
  }

  return $vars->{'image'};

}

###############################################################################################