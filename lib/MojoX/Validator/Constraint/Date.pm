package MojoX::Validator::Constraint::Date;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

require Time::Local;

sub is_valid {
    my ($self, $value) = @_;

    my $re = $self->args->{split};
    my ($year, $month, $day) = split($re, $value);

    return 0 unless $year && $month && $day;

    eval { Time::Local::timegm(0, 0, 0, $day, $month - 1, $year); };

    return $@ ? 0 : 1;
}

1;
