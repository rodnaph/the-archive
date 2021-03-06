###############################################################################################
###############################################################################################
##
##  Profile.pm
##
###############################################################################################
###############################################################################################

package Profile;

###############################################################################################

use strict;

use constant PROFILES_DIR => main::BASE . 'files/profiles/';

use FileHandle qw( print getline );
use Encoding;

###############################################################################################
##
##  new()
##
###############################################################################################

sub new {

  my ( $pkg ) = shift();
  my ( $username ) = @_;

  my $self = bless {}, $pkg;

  $self->load( $username ) unless !$username;

  if ( $self->exists() ) {
    return $self;
  }

}

###############################################################################################
##
##  load( username )
##
###############################################################################################

sub load {

  my ( $self ) = shift();
  my ( $username ) = @_;

  $self->{username} = $username;

  my $fh = new FileHandle( $self->get_file() );

  if ( $fh ) {

    foreach my $property ( $self->get_properties() ) {

      my $value = $fh->getline();

      chomp( $value );
      $self->_property( $property => $value );

    }

    # slurp remainder
    local $/ = undef();
    $self->_property( stuff => $fh->getline() );

  }

}

###############################################################################################
##
##  exists()
##
###############################################################################################

sub exists {

  my ( $self ) = shift();

  return -e $self->get_file();

}

###############################################################################################
##
##  get_file()
##
###############################################################################################

sub get_file {

  my ( $self ) = shift();

  return PROFILES_DIR . Encoding::encode( $self->{username} ) . '.nfo';

}

###############################################################################################
##
##  get_properties()
##
###############################################################################################

sub get_properties {

  my ( $self ) = shift();

  return qw( board_name real_name gender from dob email image website stuff );

}

###############################################################################################
##
##  _property( name, value )
##
###############################################################################################

sub _property {

  my ( $self ) = shift();
  my ( $name, $value ) = @_;

  $self->{$name} = $value unless !$value;

  return $self->{$name};

}

###############################################################################################
##
##  update()
##
###############################################################################################

sub update {

  my ( $self ) = shift();

  my $fh = new FileHandle( $self->get_file(), '>' );

  foreach my $property ( $self->get_properties() ) {

    my $value = $self->_property( $property );

    $value =~ s/\n/<br \/>/g;
    $fh->print( "$value\n" );

  }

}

###############################################################################################
##
##  AUTOLOAD()
##
###############################################################################################

sub AUTOLOAD {

  my ( $self ) = shift;
  my ( $value ) = @_;

  my ( $sub_name ) = $Profile::AUTOLOAD =~ /^Profile::(.*)/;

  return eval( "\$self->_property( $sub_name => '$value' );" );

}

###############################################################################################
##
##  Profile::has_profile( username )
##
###############################################################################################

sub has_profile {

  my ( $username ) = @_;

  return -e PROFILES_DIR . Encoding::encode( $username ) . '.nfo';

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