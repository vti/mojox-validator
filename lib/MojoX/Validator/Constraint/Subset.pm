package MojoX::Validator::Constraint::Subset;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub is_valid {
    my ($self, $values) = @_;

    $values = [$values] unless ref $values eq 'ARRAY';

    foreach my $value (@$values) {
        return 0 unless grep { $value eq $_ } @{$self->args};
    }

    return 1;
}

1;
