#!/usr/bin/perl

use strict;
use warnings;

use lib ( '/home/skinorg/lib' );
use Skinflowers::Database;
use FileHandle qw( getline );

# connect to database
my $db = new Skinflowers::Database( db => 'skinorg_msgboard', user => 'skinorg', pass => 'bling52' );

# open users file
my $fh = new FileHandle( 'data/msgboard_users' );

# set first user id
my $res = $db->query( ' SELECT user_id FROM users ORDER BY user_id DESC ' );
my $user_id = $res->{user_id} || 0;

# loop through file contents
while ( my $line = $fh->getline() ) {

  # get data
  my ( $user, $pass ) = split( /:#:#:/, $line );

  # create sql insert statement
  my $sql = ' INSERT INTO users ( user_id, name, pass ) ' .
            ' VALUES ( ' . $user_id++ . ', ' . $db->quote($user) . ', ' . $db->quote($pass) . ' )';

  # insert into database
  $db->execute( $sql );

}

# close filehandle
$fh->close();

# close database connection
$db = undef();

# send http headers
print "Content-type: text/html\n\n";

# print output
print <<EOT;
<html>
<head>
<title>Done</title>

</head>

<body>

<h2>Done</h2>

</body>
</html>
EOT

# End.