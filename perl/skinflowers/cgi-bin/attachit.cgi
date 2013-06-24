#!/usr/bin/perl

### User variables - you may change things in this section as indicated ###

# Change this to the correct path to Sendmail for your system #
$mailprog="/usr/lib/sendmail";

# Change this to the LITERAL PATH to the files you wish to mail. Do not forget the ending / #
$filelocation="../www/mcjesus/images/";

# Change this to the email address you want mails to be sent FROM and leave \ behind the @ sign#
$adminmail="Postcards\@McJesus.com";

# Change this to the name you want mails to be sent FROM #
$adminname="McJesus.com Postcards";

# Change this to reflect the subject line you require for your mails #
$subjectline="A McJesus.com Postcard";

# Change this to show the message you want to include (i.e. the body of the email). #
# A new line is entered by using \n e.g. Hi there\n\nThank-you for your interest in blah blah #
# Note that "Dear Name\n\n" has been inserted for you automatically, Name being the name submitted #
$message="Brave New McWorld - what follows is a list of trademarks for which McDonalds has applied ...\n\nMcTime McFolks McFamily McMom McBaby Kids Will Be McKids McRead A Book McBuddy McMemories McMagination McScholar McMath McQuestion McSymphony McThriller McRoom Service McPenpal McMason Mug McHoliday McHappenings McMarketing McLimited Edition McMagazine McRock-N-Roll Cafe McTreasure Island McFun & Fitness Factory McProduct McVideo McMarket McStock McMillions McMeals For Wheels McPac McWorld Fantasy Sweepstakes I Got Your Number McScratch-It McFortune Cookie McSmile McNature Trail McGreen McBunny McTravel McData McCajun McDonaldlandia McLennium McSpace Station McShuttle Planet McPlay McLeaps & Bounds McHappy Day McStop\n\n... excuse me while I McPuke\n";

# Change this to the URL of the screen you want to display after the user has submitted the form #
#(i.e. a confirmation screen)#
$returnscreen="http://www.skinflowers.org/mcjesus/index.shtml";

# DO NOT alter anything from here on #

read (STDIN,$temp,$ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$temp);
foreach $item(@pairs)
{
($key,$content)=split (/=/,$item);
$content=~tr /+/ /;
$content=~s /%(..)/pack("c",hex($1))/ge;
$fields{$key}=$content;
}

require ("mimetypes.pl");

&sendproduct;

sub sendproduct
{

$file=$filelocation.$fields{'attachment'};
($ext) = $file =~ m,\.([^\.]*)$,;
$ext =~ tr,a-z,A-Z,;
$fext=&mimetype($ext);

        
my @boundaryv = (0..9, 'A'..'F');
srand(time ^ $$);
for (my $i = 0; $i++ < 24;)
{
$boundary .= $boundaryv[rand(@boundaryv)];
}

open MAIL, "| $mailprog -t";
print MAIL "To: $fields{'email'}($fields{'name'})\n";
print MAIL "From: $adminmail ($adminname)\n";
print MAIL "MIME-Version: 1.0\n";
print MAIL "Subject: $subjectline\n";
print MAIL "Content-Type: multipart/mixed; boundary=\"------------$boundary\"\n";
print MAIL "\n";
print MAIL "This is a multi-part message in MIME format.\n";
print MAIL "--------------$boundary\n";
print MAIL "Content-Type: text/plain; charset=us-ascii\n";
print MAIL "Content-Transfer-Encoding: 7bit\n\n";
print MAIL "Dear $fields{'name'},\n\n";
print MAIL $message;
print MAIL "\n";
print MAIL "This McJesus Postcard was sent by $fields{'from'} via www.McJesus.com\n";
print MAIL "--------------$boundary\n";
print MAIL "Content-Type: $fext; name=\"$fields{'attachment'}\"\n";
print MAIL "Content-Transfer-Encoding: base64\n";
print MAIL "Content-Disposition: attachment; filename=\"$fields{'attachment'}\"\n\n";

my $buf;
$/=0;
open INPUT, "$file";
binmode INPUT if ($^O eq 'NT' or $^O eq 'MSWin32');
while(read(INPUT, $buf, 60*57))
{
print MAIL &encode_base64($buf);
}
close INPUT;

print MAIL "\n--------------$boundary--\n";
print MAIL "\n";
close MAIL;
print "Location: $returnscreen\n\n";
exit();
}


sub encode_base64 #($)
{
my ($res, $eol, $padding) = ("", "\n", undef);

while (($_[0] =~ /(.{1,45})/gs))
{
$res .= substr(pack('u', $1), 1);
chop $res;
}

$res =~ tr#` -_#AA-Za-z0-9+/#;               		# ` help emacs
$padding = (3 - length($_[0]) % 3) % 3;   		# fix padding at the end

$res =~ s#.{$padding}$#'=' x $padding#e if $padding;    # pad eoedv data with ='s
$res =~ s#(.{1,76})#$1$eol#g if (length $eol);          # lines of at least 76 characters

return $res;
}