package MojoX::Validator::Bulk;

use strict;
use warnings;

use base 'Mojo::Base';

__PACKAGE__->attr(fields => sub { [] });

sub each {
    my $self = shift;
    my $cb   = shift;

    foreach my $field (@{$self->fields}) {
        $cb->($field);
    }

    return $self;
}

1;
