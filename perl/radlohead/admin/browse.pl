###############################################################################################
###############################################################################################
##
##  browse.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead';
use constant URL_BASE => '/admin';

use DirHandle;
use FileHandle qw( getline );

###############################################################################################

my $curr = get_curr();

###############################################################################################

$curr = '/' unless $curr;

if ( $curr =~ /\/$/ ) {
  show_dir();
}
else {
  show_file();
}

###############################################################################################
##
##  show_file()
##
###############################################################################################

sub show_file {

  print <<EOT;
Content-type: text/html

<html>
<head>
<title>$curr</title>
</head>

<body>

<p>
[
<a href="@{[ URL_BASE . '/' ]}browse.pl@{[ get_parent($curr) ]}">back</a>
|
<a href="@{[ URL_BASE ]}$curr">download</a>
]
</p>

<p><hr /></p>

<span style="font-family:courier new; font-size: 10pt;">

EOT

  if ( -B BASE . $curr ) {
    print qq{

<p>Binary File, click download to potentially view</p>

    };
  }
  else {

    my $fh = new FileHandle( BASE . $curr );

    while ( my $line = $fh->getline() ) {
      $line =~ s/ /&nbsp;/g;
      $line =~ s/</&lt;/g;
      $line =~ s/>/&gt;/g;
      $line =~ s/\n/<br \/>/g;
      print $line;
    }

    $fh->close();

  }

print <<EOT;

</span>

</body>
</html>

EOT

}

###############################################################################################
##
##  show_dir()
##
###############################################################################################

sub show_dir {

  my $dh = new DirHandle( BASE . $curr );

  print <<EOT;
Content-type: text/html

<html>
<head>
<title>Browsing - $curr</title>
</head>

<body>

<h2>Contents of @{[ URL_BASE ]}$curr</h2>

<p><hr /></p>

<p>
<table width="100%" border="0">
EOT
if ( !$dh ) { print $curr; }
  while ( my $file = $dh->read() ) {

    my $action = URL_BASE . '/' . get_action( $file );

    print qq{
 <tr>
  <td>
   <a href="$action">$file</a>
  </td>
 </tr>

    };

  }

  $dh->close();

  print <<EOT;

</table>

</p>

<p><hr />

<small>radlohead.com</small></p>

</body>
</html>

EOT

}

###############################################################################################
##
##  get_action( file ) : action
##
###############################################################################################

sub get_action {

  my ( $file ) = @_;

  # curr dir
  $file eq '.' and return "browse.pl$curr";

  # parent dir
  $file eq '..' and return 'browse.pl' . get_parent($curr);

  # sub dir
  (-d BASE . $curr . $file) and return "browse.pl$curr$file/";

  # file
  return 'browse.pl' . $curr . $file;

}

###############################################################################################
##
##  get_curr()
##
###############################################################################################

sub get_curr {

  my $script = 'browse.pl';

  $ENV{PATH_INFO} =~ /$script(.*)$/;

  return $1;

}

###############################################################################################
##
##  get_parent( current )
##
###############################################################################################

sub get_parent {

  my ( $current ) = @_;

  my $end = ( $current =~ /\/$/ ) ? '/' : '';

  $current =~ /^(.*\/).*$end$/s;

  return ($1) ? $1 : '/';

}

###############################################################################################
###############################################################################################