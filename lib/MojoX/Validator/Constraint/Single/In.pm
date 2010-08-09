package MojoX::Validator::Constraint::Single::In;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub is_valid {
    my ($self, $value) = @_;

    return grep { $value eq $_ } @{$self->args};
}

1;
