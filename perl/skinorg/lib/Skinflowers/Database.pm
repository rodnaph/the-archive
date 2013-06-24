###############################################################################################
###############################################################################################
##
##  Database()
##
###############################################################################################
###############################################################################################

package Skinflowers::Database;
 
###############################################################################################

use strict;
use warnings;

use DBI;
use Skinflowers::DatabaseResult;
use Skinflowers::SubArgs;

###############################################################################################
##
##  new( db, user, pass )
##
###############################################################################################

sub new {

  my ( $pkg ) = shift();
  my $args = new Skinflowers::SubArgs( @_ );

  # bless instance of self
  my $this = bless { errors => $args->errors() }, $pkg;

  # connect to database
  $this->{dbh} = DBI->connect( 'DBI:mysql:database=skinorg_' . $args->db() . ';host=localhost',
                               $args->user(), $args->pass(), {RaiseError => 1} );

  # return self
  return $this;

}

###############################################################################################
##
##  query( sql )
##
###############################################################################################

sub query {

  my ( $this ) = shift();
  my ( $sql ) = @_;

  # prepare and execute statement handler
  my $sth = $this->{dbh}->prepare( $sql );
  $sth->execute();

  # check command was ok, if so return results
  $this->error( 'Error preparing statement handler' ) unless $sth;

  # get and return results
  return new Skinflowers::DatabaseResult( $sth );

}

###############################################################################################
##
##  execute( sql )
##
###############################################################################################

sub execute {

  my ( $this ) = shift();
  my ( $sql ) = @_;

  # execute command
  $this->{dbh}->do( $sql );

}

###############################################################################################
##
##  error( message )
##
###############################################################################################

sub error {

  my ( $this ) = shift();
  my ( $message ) = @_;

  # if errors on then report and bail
  if ( $this->errors() ) {
    print "Database Error: $message\n";
    exit();
  }

}

###############################################################################################
##
##  AUTOLOAD()
##
###############################################################################################

sub AUTOLOAD {

  my ( $this ) = shift();

  # get full sub name
  my ( $sub ) = $Skinflowers::Database::AUTOLOAD;

  # erase all not of interest
  $sub =~ s/^.*:://;

  # call subroutine on database handle
  $this->{dbh}->$sub( @_ );

}

###############################################################################################
##
##  DESTROY()
##
###############################################################################################

sub DESTROY {

  my ( $this ) = shift();

  # close the database connection
  $this->{dbh}->disconnect();

}

###############################################################################################

1;

###############################################################################################
###############################################################################################