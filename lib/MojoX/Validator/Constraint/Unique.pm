package MojoX::Validator::Constraint::Unique;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub error {'Values are not unique'}

sub is_single {0}

sub is_valid {
    my ($self, $values) = @_;

    my %values = map { $_ => 1 } @$values;

    return 0 unless keys %values == @$values;

    return 1;
}

1;
