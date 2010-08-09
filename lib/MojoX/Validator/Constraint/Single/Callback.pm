package MojoX::Validator::Constraint::Single::Callback;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub error {'Wrong format'}

sub is_valid {
    my ($self, $value) = @_;

    my $cb = $self->args;

    return $cb->($value);
}

1;
