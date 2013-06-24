###############################################################################################
###############################################################################################
##
##  main.pl
##
###############################################################################################
###############################################################################################

use strict;
use FileHandle qw( getline );

###############################################################################################

use constant BASE => 'e:/sites/radlohead/';
use constant LIB => BASE . 'journals/lib';
use lib ( LIB );

###############################################################################################

require 'output.lib';
require 'main.lib';

###############################################################################################

j_header();

my $text = <<EOT;

<p>Welcome to the Journals section of radLohead, where you can either make your own journal,
or view the journals of other radLohead users.</p>

<p>It's nice and simple to use, below is a list of all the journals here, just click on the
names to view them.  Or if you want to create your own journal then click the <b>create</b>
button in the menu above.</p>

<p>Enjoy!</p>

EOT

print_box( 'Journals', $text );

##
##  list journals...
##

start_box( 'Archive' );
print_text( '<p>Listed below are all the journals currently on our system.  They\'re listed in ' .
            'no particular order, just browse them as you want.</p>' );

my $journals = 0;
my $fh = new FileHandle( get_journals_file() );
while( my $journal = $fh->getline() ) {
  $journals = 1;
  chomp( $journal );
  my $color = getUserColor($journal);
  print_text( "<a style=\"text-decoration:none;\" href=\"journal.pl?user=" . URLEncode($journal) . "\"><b><font color=\"$color\">$journal</font></b></a><br />\n" );
}

if (!$journals) {
  print_text( '<p><b>No journals currently on the system.</b></p>' );
}

print_text( '<p>To remove your journal, just click the <b>remove</b> button above and follow ' .
            'the instructions that follow.' );
end_box();

footer();

###############################################################################################
###############################################################################################