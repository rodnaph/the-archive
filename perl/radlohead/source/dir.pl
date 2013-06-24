###############################################################################################
###############################################################################################
##
##  dir.pl
##
###############################################################################################
###############################################################################################

use strict;
use DirHandle;
use CGI;

###############################################################################################

my $ids = 1;
my $vdir = '';
my $dir = 'f:/newmind/radiohead';
my @secure_folders = qw( /admin /files /files/users /files/mailbox );

###############################################################################################

print <<EOT;
Content-type: text/html

<html>
<head>
<title>DirectoryThingy</title>

<link href="Default.css" rel="stylesheet" type="text/css" />

<script language="javascript" type="text/javascript" src="FileTypes.js"></script>
<script language="javascript" type="text/javascript" src="Browsers.js"></script>
<script language="javascript" type="text/javascript" src="FileObj.js"></script>
<script language="javascript" type="text/javascript" src="Folders.js"></script>
<script language="javascript" type="text/javascript">

EOT

draw_dir( $dir, $vdir, 1 );

print <<EOT;

</script>

</head>

<body>
</body>
</html>
EOT

###############################################################################################
##
##  draw_dir( dir, vdir, root )
##
###############################################################################################

sub draw_dir {

  my ( $dir, $vdir, $root ) = @_;

  my $dh = new DirHandle( $dir );
  my $id;

  if ( $dh ) {

    $id = $ids++;
    my $type = ($root) ? 'Drive' : 'Folder';
    my $is_secure = is_secure_folder( $vdir );

    print "var Fld$id = new $type( '" . get_folder($dir) . "', $is_secure );";

    while ( my $file = $dh->read() ) {

      if ( $file !~ /\./ ) {
        my $sub_id = draw_dir( $dir . '/' . $file, $vdir . '/' . $file );
        if($sub_id){
          print "Fld$id.addFolder( Fld$sub_id );";
        }
      }
      elsif ( $file !~ /\.$/ && !$is_secure ) {
        print "Fld$id.addFile( new File('$file',FileTypes." . uc(get_type($file)) . ", '$vdir') );";
      }

    }
  }

  if ( $root ) {
    print "Fld$id.build();";
  }else{
    return $id;
  }

}

###############################################################################################
##
##  get_folder( dir )
##
###############################################################################################

sub get_folder {

  my ( $dir ) = @_;

  $dir =~ s/^.*\/(.*)$/$1/;

  return $dir;

}

###############################################################################################
##
##  get_type(file)
##
###############################################################################################

sub get_type {

  my ( $file ) = @_;

  $file =~ s/^.*\.(.*)$/$1/;

  return $file;

}

###############################################################################################
##
##  is_secure_folder( dir )
##
###############################################################################################

sub is_secure_folder {

  my ( $dir ) = @_;

  foreach my $sec_fld ( @secure_folders ) {
    if( $dir eq $vdir . $sec_fld ) { return 1; }
  }

  return 0;

}

###############################################################################################
###############################################################################################