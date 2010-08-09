package MojoX::Validator::Constraint::Single::Time;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub is_valid {
    my ($self, $value) = @_;

    my ($h, $m) = split(':', $value);
    return 0 unless defined $h && defined $m;

    $h =~ m/^\d+$/ || return 0;
    $h >= 0 && $h <= 23 || return 0;

    $m =~ m/^\d+$/ || return 0;
    $m >= 0 && $m <= 59 || return 0;

    return 1;
}

1;
