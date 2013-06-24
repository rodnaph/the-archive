##########################################################
##########################################################
##
##  build_index.pl
##
##########################################################
##########################################################

use strict;
use FileHandle;
use DirHandle;
use CGI;

##########################################################

use constant BASE => "f:/newmind/radiohead/";
#use constant BASE => "e:/sites/radlohead/";

use constant TO_INDEX_FILE => BASE . "files/files_to_index.txt";
use constant INDEX_FILE => BASE . "files/profiles_index";
use constant FILE_INDEX_FILE => BASE . "files/profiles_file_index";

use constant PROFILES_DIR => BASE . "profiles/";

##########################################################

my %db;
my %files;
my %words;
my $file_count = 0;

##########################################################

print "Content-type: text/html\n\nBUILDING SITE INDEX...<br>\n\n";

##
##  build file index
##

scan_dir(PROFILES_DIR,\&build_file_index);

print "FILE INDEX BUILT!<br>";

save_file_index();

print "FILE INDEX SAVED!<br>";

load_word_index();

print "WORD INDEX LOADED!<br>";

while(my $file = get_next_file()) {
  print "indexing: $file<br>";
  index_file($file);
  save_word_index();
}

print "\n...DONE!";

##########################################################
##
##  get_next_file()
##
##########################################################

sub get_next_file {

  local $/ = undef;
  my $file;

  {
    my $fh = new FileHandle(TO_INDEX_FILE);
    my $files = <$fh>;
    $fh->close();
    ($file) = split(/\n/,$files);

    $files =~ s/$file\n//;

    $fh->open(TO_INDEX_FILE,">");
    print $fh $files;

  }

  return $file;

}

##########################################################
##
##  load_word_index()
##
##########################################################

sub load_word_index {

  dbmopen my %db, INDEX_FILE, 0666;
  foreach my $key (keys %db) {
    $words{$key} = $db{$key};
  }
  dbmclose %db;

}

##########################################################
##
##  save_word_index()
##
##########################################################

sub save_word_index {

  dbmopen my %db, INDEX_FILE, 0666;
  foreach my $key (keys %words) {

    local $!;
    eval {
      $db{$key} = $words{$key};
    };
    if ($!) { print "unable to store key : $key\n"; }

  }
  dbmclose %db;

}

##########################################################
##
##  save_file_index()
##
##########################################################

sub save_file_index {

  dbmopen my %db, FILE_INDEX_FILE, 0666;

  foreach my $key (keys %files) {
    $db{$key} = $files{$key};
  }

  dbmclose %db;

}

##########################################################
##
##  scan_dir(directory,file_action,recurse)
##
##########################################################

sub scan_dir {

  my ($directory,$rs_file_action,$recurse) = @_;

  my $dh = new DirHandle($directory);
  while (my $file_or_folder = $dh->read()) {

    if ((is_folder($file_or_folder)) && ($recurse)) {
      scan_dir($directory . $file_or_folder . "/",$rs_file_action,$recurse);
    } else {
      &$rs_file_action($directory,$file_or_folder);
    }

  }
  $dh->close();

}

##########################################################
##
##  build_file_index(directory,file)
##
##########################################################

sub build_file_index {

  my ($directory,$file) = @_;

  if (file_to_index($file)) {

    $files{$file_count++} = "$file";

  }

}

##########################################################
##
##  index_file(directory,file)
##
##########################################################

sub index_file {

  my ($directory,$file) = @_;

  if (file_to_index($file)) {

    print "indexing file : $file\n";
    my ($text);

    {
      local $/ = undef;
      my $fh = new FileHandle($directory . $file);
      $text = <$fh>;
      $fh->close();
    }

    remove_html($text);
    $text =~ s/([a-z0-9]*)/index_word($directory,$file,$1)/egi;

  }

}

##########################################################
##
##  index_word(directory,file,word)
##
##########################################################

sub index_word {

  my ($directory,$file,$word) = @_;

  $word =~ s/ //g;
  $word = uc($word);

  if ($word) {

    my $file_index = get_file_index($file);

    if (defined($words{$word})) {
      if (not_yet_indexed($file_index,$word)) {
        $words{$word} .= ":$file_index";
      }
    } else {
      $words{$word} = "$file_index";
    }

  }

}

##########################################################
##
##  not_yet_indexed(file_index,word) : boolean
##
##########################################################

sub not_yet_indexed {

  my ($file_index,$word) = @_;

  my @files = split(/:/,$words{$word});

  foreach my $index (@files) {
    if ($file_index =~ /^$index$/) { return 0; }
  }

  return 1;

}

##########################################################
##
##  get_file_index(file)
##
##########################################################

sub get_file_index {

  my ($file) = @_;

  foreach my $key (keys %files) {

    if ($files{$key} eq "$file") {
      return $key;
    }

  }

}

##########################################################
##
##  remove_html(array)
##
##########################################################

sub remove_html {

  foreach (@_) {
    $_ =~ s/<.*>//g;
  }

}

##########################################################
##
##  file_to_index(file)
##
##########################################################

sub file_to_index {

  my ($file) = @_;

  if ($file =~ /\.(html|nfo)$/) { return 1; }

}

##########################################################
##
##  is_folder(folder_or_file)
##
##########################################################

sub is_folder {

  my ($folder_or_file) = @_;

  if ($folder_or_file !~ /\./) { return 1; } else { return 0; }

}

##########################################################