###############################################################################################
###############################################################################################
##
##  make.pl
##
###############################################################################################
###############################################################################################

use strict;
use DirHandle;
use constant BASE => 'c:/windows/desktop/project/source/builder/';

###############################################################################################

my $class = shift;
my $found = 0;

###############################################################################################

find_class( BASE, 'builder/', $class );

if ( !$found ) {
  print "\nError: class $class not found\n";
}

###############################################################################################
##
##  find_class( dir, vdir, class )
##
###############################################################################################

sub find_class {

  my ( $dir, $vdir, $class ) = @_;

  my $dh = new DirHandle( $dir );

  while ( $dh && ( my $file = $dh->read() ) ) {

    if ( $file !~ /\./ ) {
      find_class( $dir . $file . '/', $vdir . $file . '/', $class );
    } elsif ( $file =~ /^$class\.java$/ ) {

      my $path = $vdir . $file;
      my $pkg = $path;

      $found = 1;
      $path =~ s/\//\\/g;
      $pkg =~ s/\//./g;
      $pkg =~ s/\.java$//;

      print "\nFound class $pkg\nSpawning javac:\n\n";
      system "javac -deprecation -d c:\\jdk1.2.2\\packages $path";

    }

  }

}

###############################################################################################
###############################################################################################