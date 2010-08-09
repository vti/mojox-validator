package MojoX::Validator::ConstraintBuilder;

use strict;
use warnings;

use base 'Mojo::Base';

use Mojo::Loader;
use Mojo::ByteStream;

sub build {
    my $self = shift;
    my $name = shift;

    my $class = "MojoX::Validator::Constraint::"
      . Mojo::ByteStream->new($name)->camelize;

    # Load class
    if (my $e = Mojo::Loader->load($class)) {
        die ref $e
          ? qq/Can't load class "$class": $e/
          : qq/Class "$class" doesn't exist./;
    }

    return $class->new(args => @_ > 1 ? [@_] : $_[0]);
}

1;
