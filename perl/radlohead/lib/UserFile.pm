###############################################################################################
###############################################################################################
##
##  UserFile.pm
##
###############################################################################################
###############################################################################################

package UserFile;

###############################################################################################

use strict;

use constant USERS_DIR => main::BASE . 'files/users/';

use FileHandle qw( print getline );
use User;

###############################################################################################
##
##  new( init_str )
##
###############################################################################################

sub new {

  my ( $pkg ) = shift();
  my ( $init_str ) = @_;

  my $self = bless {}, $pkg;

  $self->{init_str} = $init_str;
  $self->load( $init_str ) unless !$init_str;

  return $self;

}

###############################################################################################
##
##  load( init_str )
##
###############################################################################################

sub load {

  my ( $self ) = shift();
  my ( $init_str ) = @_;

  $self->{init_str} = $init_str;

  my ( %users );
  my $fh = new FileHandle( $self->get_file() );

  if ( $fh ) {

    while ( my $userdata = $fh->getline() ) {

      chomp( $userdata );

      my ( $username ) = split( /:#:/, $userdata );
      my $user = new User( split( /:#:/, $userdata ) );

      $users{uc($username)} = $user;

    }

  }

  $self->{users} = \%users;

}

###############################################################################################
##
##  get_user( username )
##
###############################################################################################

sub get_user {

  my ( $self ) = shift();
  my ( $username ) = @_;

  my %users = %{ $self->{users} };

  return $users{uc($username)};

}

###############################################################################################
##
##  get_users()
##
###############################################################################################

sub get_users {

  my ( $self ) = shift();

  my ( @users );
  my %users = %{ $self->{users} };

  foreach my $username ( keys %users ) {
    push( @users, $self->get_user($username) );
  }

  return sort( @users );

}

###############################################################################################
##
##  add( user )
##
###############################################################################################

sub add {

  my ( $self ) = shift();
  my ( $user ) = @_;

  my %users = %{ $self->{users} };

  $users{ uc( $user->username() ) } = $user;

  $self->{users} = \%users;

}

###############################################################################################
##
##  delete( user )
##
###############################################################################################

sub delete {

  my ( $self ) = shift();
  my ( $user ) = @_;

  my %users = %{ $self->{users} };

  delete $users{ uc( $user->username() ) };

  $self->{users} = \%users;

}

###############################################################################################
##
##  exists( username )
##
###############################################################################################

sub exists {

  my ( $self ) = shift();
  my ( $username ) = @_;

  my %users = %{ $self->{users} };

  if ( $users{ uc($username) } ) {
    return 1;
  }

}

###############################################################################################
##
##  valid( username, password )
##
###############################################################################################

sub valid {

  my ( $self ) = shift();
  my ( $username, $password ) = @_;

  my $user = $self->get_user( $username );

  if ( $user ) {
    my $pass = $user->password();
    if ( $pass =~ /^$password$/i ) { return 1; }
  }

}

###############################################################################################
##
##  save()
##
###############################################################################################

sub save {

  my ( $self ) = shift();

  my $fh = new FileHandle( $self->get_file(), '>' );

  foreach my $user ( $self->get_users() ) {
    foreach my $property ( $user->get_properties() ) {

      my $value = eval( "\$user->$property()" );
      $fh->print( $value . ':#:' );

    }
    $fh->print( "\n" );
  }

}

###############################################################################################
##
##  AUTOLOAD()
##
###############################################################################################

sub AUTOLOAD {

  my ( $self ) = shift();

  my ( $sub_name ) = $UserFile::AUTOLOAD =~ /^UserFile::(.*)/;

  return $self->get_user( $sub_name );

}

###############################################################################################
##
##  get_file()
##
###############################################################################################

sub get_file {

  my ( $self ) = shift();

  my ( $filename ) = $self->{init_str};

  if ( $filename =~ /^[a-z]/i ) {
    ( $filename ) = $filename =~ /^(.)/;
  }
  else {
    $filename = 0;
  }

  return USERS_DIR . '_' . uc($filename) . '_.usr'
    unless !$self->{init_str};

}

###############################################################################################
##
##  UserFile::load_user( username ) : user
##
###############################################################################################

sub load_user {

  my ( $username ) = @_;

  my $users = new UserFile( $username );

  return $users->get_user( $username );

}

###############################################################################################
##
##  UserFile::valid_user( username, password )
##
###############################################################################################

sub valid_user {

  my ( $username, $password ) = @_;

  my $user = load_user( $username );

  if ( $user ) {
    my $pass = $user->password();
    if ( $pass =~ /^$password$/i ) { return 1; }
  }

}

###############################################################################################
##
##  UserFile::user_exists( username )
##
###############################################################################################

sub user_exists {

  my ( $username ) = @_;

  my $users = new UserFile( $username );

  return $users->exists( $username );

}

###############################################################################################
##
##  DESTROY()
##
###############################################################################################

sub DESTROY {
}

###############################################################################################

1;

###############################################################################################
###############################################################################################