package MojoX::Validator::Constraint::Group::Equal;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub error {'Values are not equal'}

sub is_valid {
    my ($self, $values) = @_;

    my $e = shift @$values;

    foreach (@$values) {
        return 0
          unless (!defined $e && !defined $_)
          || (defined $e && defined $_ && $e eq $_);
    }

    return 1;
}

1;
