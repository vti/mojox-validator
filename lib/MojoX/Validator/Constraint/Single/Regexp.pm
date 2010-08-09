package MojoX::Validator::Constraint::Single::Regexp;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub error {'Wrong format'}

sub is_valid {
    my ($self, $value) = @_;

    my $re = $self->args;

    return $value =~ m/$re/ ? 1 : 0;
}

1;
