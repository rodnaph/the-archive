###############################################################################################
###############################################################################################
##
##  gen_docs.pl
##
###############################################################################################
###############################################################################################

use strict;
use DirHandle;
use constant BASE => 'c:/windows/desktop/project/source/builder';

###############################################################################################

my @packages;
my $docs_dir = 'c:\\windows\\desktop\\project\\source\\docs';
my $src_path = 'c:\\windows\\desktop\\project\\source';
my $s = shift;

###############################################################################################

print "Cleaning...\n";
my $to_clean = $docs_dir;
$to_clean =~ s/\\/\//g;
clean_dir( $to_clean );
system "rmdir $docs_dir";

gen_docs() unless ( $s eq '-clean' );

###############################################################################################
##
##  gen_docs()
##
###############################################################################################

sub gen_docs {

  print "\nFetching Packages...\n";
  find_packages( BASE, 'builder' );

  print "\nSpawning JavaDoc...\n\n";
  system "mkdir $docs_dir";
  system "javadoc -d $docs_dir -sourcepath $src_path @packages\n";
  print "\n\n...JavaDoc Successful, Documention Created!\n";

}

###############################################################################################
##
##  clean_dir( dir )
##
###############################################################################################

sub clean_dir {

  my ( $dir ) = @_;

  my $del = 0;
  my @files;
  my $dh = new DirHandle( $dir );

  if ( $dh ) {
    while ( my $file = $dh->read() ) {
      if ( $file !~ /\./ ) { clean_dir( $dir . '/' . $file ); }
      elsif( $file =~ /\.(html|htm|css)$/ ) {
        $del=1;
        push( @files, { dir=>$dir, file=>$file } );
      }
    }
    $dir =~ s/\//\\/g;
    print "  Cleaning Directory: $dir...\n";
    foreach my $rh_file ( @files ) {
      print "    Removing File: $rh_file->{file}\n";
      unlink $rh_file->{dir} . '/' . $rh_file->{file};
    }
    if ( ($dir ne BASE) && $del ) {
      $dir =~ s/\//\\/g;
      system "rmdir $dir";
    }
  } else {
    unlink $dir;
  }

}

###############################################################################################
##
##  find_packages( dir, pkg )
##
###############################################################################################

sub find_packages {

  my ( $dir, $pkg ) = @_;

  my $dh = new DirHandle( $dir );
  if ( $dh ) {
    print "  Found Package: $pkg\n";
    push( @packages, $pkg );
    while ( my $file = $dh->read() ) {
      if ( $file !~ /\./ ) { find_packages( $dir . '/' . $file, $pkg . '.' . $file ); }
    }
  }

}

###############################################################################################
###############################################################################################