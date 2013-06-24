###############################################################################################
###############################################################################################
##
##  help.pl
##
###############################################################################################
###############################################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LIB => BASE . 'lib';
use lib ( LIB );

###############################################################################################

require 'msgboard.lib';

###############################################################################################

msgboard_header('Official Board Help');

start_box('Board Help');
print <<EOT;

<p>
Hey, welcome to our remote version of the official radiohead message board.  You may have
some problems with using our board... or some questions as to it's purpose etc...  let
some generalish answers follow, we hope they help...
</p>

<ul>
<li><b>Why does this thing exist?</b><br />
Well, this was created because sometimes people using the official board via the radiohead
website have problems with proxies/isp's caching the page so they can't see it update.  Thus
effectively renders the board useless to them, so this is meant to help.  It helps by going
round proxies to a certain degree, trying to ensure that the board is always visible in it's
latest state.
</li>

<li><b>So is this the radiohead board?</b><br />
Yup, you can post here or at radiohead.com, it's just the same thing.  Only here you shouldn't
have any problems with caching.
</li>

<li><b>So which username/password do i use?</b><br />
You have to use usernames that you have registered on the official board at radiohead.com
because, like we said, it IS the official board.
</li>

<li><b>So if i see a blue it's real?</b><br />
YES !  I'll say it again, it IS the official board, you're just viewing it remotely.
</li>

</ul>

<p>If you have any problems/questions we have listed then just tell us about them
<a href="//www.radlohead.com/03.pl?todo=contact">here</a>.

EOT
end_box();

footer();

###############################################################################################
###############################################################################################