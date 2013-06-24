###############################################################################################
###############################################################################################
##
##  main.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant IMG_DIR => BASE . 'files/images/profiles/';
use constant LIB => BASE . 'images/lib';
use lib ( LIB, BASE . 'lib' );

use DirHandle;
use Request;
use Dispatch;

###############################################################################################

require 'images_output.lib';

###############################################################################################

my $q = new Request;
my $d = new Dispatch;

###############################################################################################

$d->load(
         -view => \&view,
         -list => \&list
        );

$d->execute( $q->param('todo') );

###############################################################################################
##
##  list()
##
###############################################################################################

sub list {

  my $dh = new DirHandle( IMG_DIR );
  my ( %users ) = ();
  my $total = 0;

  # initialize hash
  for ( my $i=ord('A'); $i<(ord('Z')+1); $i++ ) {
    $users{chr($i)} = [];
  }

  # load hash
  while ( my $file = $dh->read() ) {
    if ( $file !~ /^(\.|\.\.)$/ ) {
      my ( $ltr ) = $file =~ /^(.)/;      
      my $ra_users = $users{uc($ltr)};
      push( @$ra_users, $file );
      $total++;
    }
  }

  images_header();

  start_box( 'List of Names' );
  print qq{

<p>
Below is a list of all the names.
</p>

<table width="100%" cellspacing="0" cellpadding="0" border="0"><tr bgcolor="#ff0000"><td>
 <table width="100%" cellspacing="1" cellpadding="2" border="0">

  };

  for ( my $i=ord('A'); $i<ord('N'); $i++ ) {

    my $ltr_1 = chr($i);
    my $ltr_2 = chr($i + 13);

    print qq{

 <tr>
  <td bgcolor="#000000" background="/files/images/site/back.gif">
  <table width="100%">
   <tr>
    <td bgcolor="#ff0000"> &nbsp;<b>$ltr_1</b></td>
   </tr>
   <tr>
    <td align="right">

    };

    draw_users( $users{$ltr_1} );

    print qq{
    </td>
   </tr>
  </table>

  </td>
  <td bgcolor="#000000" background="/files/images/site/back.gif">
  <table width="100%">
   <tr>
    <td bgcolor="#ff0000"> &nbsp;<b>$ltr_2</b></td>
   </tr>
   <tr>
    <td align="right">

    };

    draw_users( $users{$ltr_2} );

    print qq{
    </td>
   </tr>
  </table>
  </td>
 </tr>

    };

  }

  print qq{

 </table>
</td></tr></table>

<p align="right">
<i>$total images total</i>
</p>

  };

  end_box();

  images_footer();

}

###############################################################################################
##
##  draw_users( ra_users )
##
###############################################################################################

sub draw_users {

  my ( $ra_users ) = @_;

  foreach my $file ( @$ra_users ) {
    my ( $user, $ext ) = $file =~ /^(.*)(\.\w+)$/;
    print qq{

<a href="show.pl?user=@{[ URLEncode($file) ]}" target="_blank">@{[ URLDecode($user) ]}</a><br />

    };
  }

}

###############################################################################################
##
##  view()
##
###############################################################################################

sub view {

  my $ltr = $q->param('letter');
  my $dh = new DirHandle( IMG_DIR );
  my $no_images = 1;

  images_header();

  start_box( "Images for $ltr" );

  while ( my $file = $dh->read() ) {
    if ( $file =~ /^$ltr/i ) {
      $no_images = 0;
      $file =~ /(.*)\.\w+$/;
      my $user = URLDecode($1);
      my $color = getUserColor($user);
      print <<EOT;

<b><a href="show.pl?user=@{[URLEncode($file)]}" target="_blank"><font color="$color">$user</font></a></b>
<br />

EOT

    }
  }

  if ( $no_images ) {
    print '<p>Sorry, but there aren\'t any images under this letter.</p>';
  }

  end_box();

   print '<p align="center">[ ';

  for ( my $i=ord('A'); $i<(ord('Z')+1); $i++ ) {
    my $ltr = chr($i);
    print qq{ <a href="main.pl?todo=view|letter=$ltr">$ltr</a> };
  }

  print ' ]<p>';

  images_footer();

}

###############################################################################################
##
##  draw_page()
##
###############################################################################################

sub draw_page {

  ##
  ##  count images
  ##

  my $dh = new DirHandle( IMG_DIR );
  my %images = undef();
  my $total = 0;

  for ( my $i=ord('A'); $i<(ord('Z')+1); $i++ ) {
    $images{chr($i)} = 0;
  }

  while ( my $file = $dh->read() ) {
    if ( $file !~ /^(\.|\.\.)$/ ) {
      $file =~ /^(.)/;
      $images{uc($1)}++;
      $total++;
    }
  }

  ##
  ##  draw the page
  ##

  images_header();

  print_box( 'Directory', qq{

<p>
Welcome to radLohead images !  This is basically a big collection of the images that the users
here have uploaded, below is just a big list you can browse.  Simple.  Enjoy.
</p>

<p>
If you want to upload your own image then you can do so <a href="upload.pl">HERE</a>.
</p>

  }, 'ImagesDirectory' );

  start_box( 'Links to the Images' );

  print qq{

<p>Just click the links below to view the images.  If you find any that
are broken or that you find offensive just get in touch with us and
we\'ll see that we can do.</p>
<br />

<table width="100%" cellspacing="1" cellpadding="2" border="0"><tr bgcolor="#ff0000"><td>
 <table width="100%" cellspacing="1" cellpadding="2" border="0">

  };

  for ( my $i=ord('A'); $i<(ord('M')+1); $i++ ) {

    my $ltr_1 = chr($i);
    my $ltr_2 = chr($i + 13);

    print qq{
   <tr>
    <td bgcolor="#000000" background="/files/images/site/back.gif">
     <table width="100%"><tr><td>
      &nbsp; <b><a href="main.pl?todo=view|letter=$ltr_1">$ltr_1</a></b>
     </td><td align="right">
      ($images{$ltr_1}) &nbsp;
     </td></tr></table>
    </td>
    <td bgcolor="#000000" background="/files/images/site/back.gif">
     <table width="100%"><tr><td>
      &nbsp; <b><a href="main.pl?todo=view|letter=$ltr_2">$ltr_2</a></b>
     </td><td align="right">
      ($images{$ltr_2}) &nbsp;
     </td></tr></table>
    </td>
   </tr>
    };

  }

  print qq{

 </table>
</td></tr></table>

<p align="right">
<i>$total images total</i>
</p>

  };

  end_box();

  images_footer();

}

###############################################################################################
###############################################################################################