##################################################################
##################################################################
##
##  home.pl
##
##################################################################
##################################################################

use strict;

#use constant BASE => 'f:/newmind/radiohead/';
use constant BASE => 'd:/sites/radlohead/';
use constant AP_FILE => BASE . 'admin/AgainstPerfection/text';
use constant LIB => BASE . 'lib/';
use lib ( LIB );

use FileHandle qw( getline );
use LWP::Simple;

##################################################################

require 'output.lib';
require 'tracker.lib';

##################################################################

my $posts = get( 'http://www.radiohead.com/msgboard/data.txt' );

##################################################################

header( 'home' );

print_box( 'Welcome To Radlohead', qq{

<p>If you're thinking radiohead.com ?  Then you're almost right.  This site is about the wonderful
place that is the radiohead message board, beloved to many, <b>$posts</b> posts and counting!</p>

<p>Just use the menu buttons at the top of the screen to navigate your way around the site,
it's pretty simple so you shouldn't get lost.  If you do have any problems though just tell 
us about them <a href="/feedback">here</a> and we'll see what we can do.</p>

});

##
##  add against perfection bit...
##

my ( $text, $title ) = ();

{
  my $fh = new FileHandle( AP_FILE );

  $title = $fh->getline();
  local $/ = undef();
  $text = $fh->getline();
}

start_box( $title );
print $text;
print_comments( 'AgainstPerfection' );
end_box();

##
##  end
##

$text = <<EOT;

EOT

start_box( 'Site News' );
print qq{

<p>So, the festive season is over, and we're all still alive.  Again.  There has been a
comments feature added, while looking round the site you may see the 'leave comment | view comments'
boxes (like on this page, i'm sure you can guess what they're about.
</p>

<p>
<b>BIG NEWS!</b> We have added an upload facility for you to upload your images with. YAY!
It's been a long time coming but it's here at last.  So... USE IT! heh heh.  You can access
it <a href="/images"><b>HERE</b></a>.
</p>

<p>
Against Perfection continues to entertain me (and the rest of you i hope) with her wonderful
column on the front page just above.  Keep it up hun!
</p>

<p>
If you would like to have a similar section then just get in touch with us
<a href="/feedback/email.pl">here</a> and we'll be only to happy to set it up for you.  Yup.

<p>The End.</p>

};
print_comments( 'SiteNews' );
end_box();

footer(1);

##################################################################