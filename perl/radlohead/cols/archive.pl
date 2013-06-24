###############################################################################################
###############################################################################################
##
##  columns.pl
##
###############################################################################################
###############################################################################################

use strict;

#use constant BASE => 'f:/newmind/radiohead/';
use constant BASE => 'd:/sites/radlohead/';
use constant ENTRIES_PER_PAGE => 10;
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle qw( getlines );
use Request;

###############################################################################################

require 'output.lib';
require 'columns.lib';

###############################################################################################

my $q = new Request();

###############################################################################################

header( 'Columns', '','', 'Columns' );
open_tr();

start_box( 'Columns', 'Columns' );

print qq{

<p>
Ok, archived here are all the updates people have made to their various
columns since 11/02/02.  Only the most recent are displayed below, others can
be viewed by clicking the more button.  Enjoy.
</p>

<table width="100%">
 <tr>
  <th align="center">Title</th>
  <th align="center">Author</th>
  <th align="center">Date</th>
 </tr>

};

# get data
my $offset = ($q->param('pos')) ? $q->param('pos') : 0;
my $position = 0;
my $fh = new FileHandle( get_archive_file() );
my @cols = $fh->getlines();

$fh->close();

# wind file
while ( $position < $offset ) { $position++ }

# draw columns
my $drawn = 0;
while ( (my $data = $cols[$position]) && ($drawn < ENTRIES_PER_PAGE) ) {

  my ( $date, $path, $title, $author, $desc ) = split( /:#:/, $data );

  my $base = BASE;

  $path =~ s/$base//;

  print qq{
 <tr>
  <td align="center">
   <a href="/$path">$title</a>
  </td>
  <td align="center">
   @{[ user_html($author) ]}
  </td>
  <td align="center">
   <i>$date</i>
  </td>
 </tr>

  };

  $position++;
  $drawn++;

}

my $more_link = ( $cols[$position] ) ? qq{ <b><a href="archive.pl?pos=@{[ $offset + ENTRIES_PER_PAGE ]}">More</a></b> } : '';
my $back_link = ( $offset ) ? qq{ <b><a href="archive.pl?pos=@{[ $offset - ENTRIES_PER_PAGE ]}">Back</a></b> } : '';

print qq{
 <tr>
  <td align="left">
   $back_link
  </td>
  <td></td>
  <td align="right">
   $more_link
  </td>
 </tr>
</table>
<br />
};
end_box();

footer();

###############################################################################################
###############################################################################################