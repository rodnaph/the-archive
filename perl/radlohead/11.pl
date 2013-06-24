###############################################################################################
###############################################################################################
##
##  11.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getline );
use DirHandle;
use Request;

###############################################################################################

require 'output.lib';

###############################################################################################

my $q = new Request();

###############################################################################################
##
##  draw a page...
##
###############################################################################################

if ( $ENV{QUERY_STRING} ) {

  my $name = $ENV{QUERY_STRING};

  header( $name );
  open_tr();

  print_section( $name );

  footer();

}

###############################################################################################
##
##  main page...
##
###############################################################################################

else {

  header();
  open_tr();

  start_box( 'Pages' );
  print qq{

<p>
All of the current pages are listed below, just click on the names to view
them.  If you want to get a page of ur own then just read a lil lower down the
page for info on how to apply.
</p>

  };

  ##
  ##  ADDING LINKS
  ##  TO PAGES
  ##

  my $dh = new DirHandle( BASE . 'admin' );

  while ( my $f = $dh->read() ) {

    if ( -e BASE . 'admin/' . $f . '/text' ) {

      print qq{
<b><a href="11.pl?$f">$f</a></b>
<br />
      };

    }

  }

  end_box();

  print_box( 'Applying', qq{

<p>
This is a kinda new idea, but it's been brewing for a lil while now.  Seeing
as this site is for the lovely rhmb followers, we think it's only right that they have
more control over the site.
</p>

<p>
So, we're offering the chance for some people to have their own pages here at radlohead.
We don't mean something that's just like ur profile, we want it to have something to do
with the people or the site, like stuff the happens on the board, or between people, or
whatever you can think up, just aslong as it's something original.
</p>

<p>
If you want to apply just go <a href="/feedback">HERE</a> and we'll sort it out.
</p>

<p>So, get thinking.</p>

  }, 'Applying' );

  footer();

}

###############################################################################################
###############################################################################################