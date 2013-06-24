###############################################################################################
###############################################################################################
##
##  main.pl
##
###############################################################################################
###############################################################################################

use strict;

###############################################################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

###############################################################################################

require(BASE . "hotornot/lib/output.lib");

###############################################################################################

hotornot_header();

heading( "HotOrNot" );

my $text = <<EOT;
<p>Welcome to the HotOrNot section at radLohead, where the users can submit pictures of themselves
and have them voted on by anyone who drops by.</p>

<p>We must stress that this is just meant for fun, and while we can't control what pictures are added,
we will remove any that people take offence to if we are notified about them.</p>

<p>The DB was reset and some changes were made last night if anyone's wondering where their pic
went.  Sorry, but now people can only register 1 pic for each username.  And there's a link
showing the url of the pic so you can click on it to try and reach it if it won't load
properly.  Hope it helps...</p>

<p>Have fun!<br />
:/
</p>
EOT

print_text( $text );

footer( 1 );

###############################################################################################
###############################################################################################