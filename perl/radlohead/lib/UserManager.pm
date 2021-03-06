###############################################################################################
###############################################################################################
##
##  UserManager.pm
##
###############################################################################################
###############################################################################################

package UserManager;

###############################################################################################

use strict;

use UserFile;
use User;
use Profile;

###############################################################################################
##
##  new()
##
###############################################################################################

sub new {

  my ( $pkg ) = shift();

  my $self = bless {}, $pkg;

  return $self;

}

###############################################################################################
##
##  user( username )
##
###############################################################################################

sub user {

  my ( $self ) = shift();
  my ( $username ) = @_;

  my $user_file = $self->get_users( $username );

  return $user_file->get_user( $username );

}

###############################################################################################
##
##  users( str )
##
###############################################################################################

sub users {

  my ( $self ) = shift();
  my ( $str ) = @_;

  my $init_str = $self->_init_str( $str );

  if ( !defined( $self->{$init_str} ) ) {
    $self->load( $init_str );
  }

  return $self->{$init_str};

}

###############################################################################################
##
##  insert( user )
##
###############################################################################################

sub insert {

  my ( $self ) = shift();
  my ( $user ) = @_;

  my $users = $self->get_users( $user->username() );

  $users->add( $user );

}

###############################################################################################
##
##  update()
##
###############################################################################################

sub update {

  my ( $self ) = shift();

  foreach my $init_str ( split( /:/, $self->{init_strs} ) ) {

    my $users = $self->{$init_str};
    $users->save();

  }

}

###############################################################################################
##
##  delete( user )
##
###############################################################################################

sub delete {

  my ( $self ) = shift();
  my ( $user ) = @_;

  my $users = $self->get_users( $user->username() );

  $users->delete( $user );

}

###############################################################################################
##
##  load( init_str )
##
###############################################################################################

sub load {

  my ( $self ) = shift();
  my ( $init_str ) = @_;

  $self->{$init_str} = new UserFile( $init_str );
  $self->{init_strs} .= $init_str . ':';

}

###############################################################################################
##
##  valid( username, password )
##
###############################################################################################

sub valid {

  my ( $self ) = shift();
  my ( $username, $password ) = @_;

  my $users = $self->get_users( $username );

  return $users->valid( $username, $password );

}

###############################################################################################
##
##  exists( username )
##
###############################################################################################

sub exists {

  my ( $self ) = shift();
  my ( $username ) = @_;

  my $users = $self->get_users( $username );

  return $users->exists( $username );

}

###############################################################################################
##
##  profile( username )
##
###############################################################################################

sub profile {

  my ( $self ) = shift();
  my ( $username ) = @_;

  return Profile::has_profile( $username );

}

###############################################################################################
##
##  _init_str( text )
##
###############################################################################################

sub _init_str {

  my ( $self ) = shift();
  my ( $text ) = @_;

  if ( $text =~ /^[a-z]/i ) { ( $text ) = $text =~ /^(.)/; }
    else { $text = 0; }

  return uc( $text );

}

###############################################################################################
##
##  AUTOLOAD()
##
###############################################################################################

sub AUTOLOAD {

  my ( $self ) = shift();

  my ( $sub_name ) = $UserManager::AUTOLOAD =~ /^UserManager::(.*)/;
  my $users = $self->get_users( $sub_name );

  return $users->get_user( $sub_name );

}

###############################################################################################
##
##  DESTROY()
##
###############################################################################################

sub DESTROY {

  my ( $self ) = shift();

}

###############################################################################################

1;

###############################################################################################
###############################################################################################