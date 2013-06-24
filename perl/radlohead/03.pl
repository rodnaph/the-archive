################################################################
################################################################
##
##  03.pl
##
################################################################
################################################################

use strict;

use constant BASE => 'f:/newmind/radiohead/';
use constant LINKS_FILE => BASE . 'files/links.nfo';
use constant LIB => BASE . 'lib';
use lib ( LIB );

use FileHandle;
use Dispatch;
use Request;

################################################################

require 'output.lib';

################################################################

my $q = new Request;
my $d = new Dispatch;
$d->load(
          -contact => sub { print_redirect( '/feedback' ) },
          -links => \&draw_links,
          -addLink => \&add_link,
        );

################################################################

header( 'Other' );
open_tr();

# dispatching
$d->execute( $q->param('todo') );

footer();

##################################################
##
##  draw_links()
##
##################################################

sub draw_links {

  start_box( 'Links Added by You' );
  print_text( "<p>Below are links that people have added here, we can't garauntee that they'll " .
              "all work, or you'll like what they're about, just try some.</p>" );

  my $fh = new FileHandle(LINKS_FILE);
  my $color = "#ff0000";
  while(my $link_info = <$fh>) {
    my ($url,$name) = split(/:#:/,$link_info);
    print_text("<a target=\"_blank\" href=\"$url\"><b><font color=\"$color\" style=\"text-decoration:none\">$name</font></b></a><br />");
    if ($color eq "#ff0000") { $color = "#ffffff"; } else { $color = "#ff0000"; }
  }
  $fh->close();

  print_comments( 'SiteLinks' );
  end_box();

  my $top_links = <<EOT;

<p>
These are some of our favourite websites who have lovely links we can use.  Just mail
us if you have an image you want us to link to your site with.
</p>

<a href="http://www.theonion.com" target="_blank"><img
   src="//www.radlohead.com/files/images/site/theonion.gif"
   alt="The Onion" height="31" width="88" border="0" /></a>
<br />
<a href="http://www.followmearound.com" target="_blank"><img
   src="//www.radlohead.com/files/images/site/followmearound.jpg"
   alt="Follow Me Around" height="37" width="240" border="0" /></a>

EOT

  start_box( 'Our Top Links' );
  print_text( $top_links );
  print_comments( 'SiteTopLinks' );
  end_box();

  start_box( 'Adding a Link' );

  my $text = <<EOT;

<p>To add a link, just fill out the form and click <b>ADD LINK</b></p>

EOT

  print_text($text);

  start_form("03.pl");
  hidden_field("todo","addLink");
  text_field("url","url",50,50,"http://");
  text_field("link name","name");
  end_form("ADD LINK");
  end_box();

}

##################################################
##
##  add_link()
##
##################################################

sub add_link {

  my ($url,$name) = ($q->param("url"),$q->param("name"));

  my $fh = new FileHandle(LINKS_FILE,">>");
  print $fh "$url:#:$name\n";
  $fh->close();

  start_box( 'Link added' );
  print_text("<p>Your link to <b><a href=\"$url\" target=\"_blank\">$url</a></b> has been added!</p>");
  end_box();

}

##################################################
##
##  draw_page()
##
##################################################

sub draw_page {

  my $text = <<EOT;

<p>About the site...what can we say...some info ?</p>

<p>First, just above and to the left you'll see some links to our links page (where you can add
your own links) and to the contact page which you can use to tell us about any problems
your having, suggestions you like, or how much we suck.</p>

<p>Ok, history. The site was originally set up at the start of 2001 at http://radioheadboard.hypermart.net.  It
started as just a list of names but the interest in the site kinda meant that it needed to be expanded.
So it was.</p>

<p>Then after a little hosting trouble with hypermart the wonderful Evil Thom kindly
allowed us to use this space to host the site.</p>

<p>And here we are, not much of a history, but lets hope there is a future.  Damn that was cheesy.</p>

EOT

  print_box( 'The Site', $text);

}

##################################################