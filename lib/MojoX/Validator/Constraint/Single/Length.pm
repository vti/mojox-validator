package MojoX::Validator::Constraint::Single::Length;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub error {'Wrong length'}

sub is_valid {
    my ($self, $value) = @_;

    my $len = length $value;

    my ($min, $max) = @{$self->args};

    return $len >= $min && $len <= $max ? 1 : 0;
}

1;
