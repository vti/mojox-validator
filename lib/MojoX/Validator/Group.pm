package MojoX::Validator::Group;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Validator::ConstraintBuilder;

__PACKAGE__->attr('name');
__PACKAGE__->attr('error');
__PACKAGE__->attr(constraints => sub { [] });
__PACKAGE__->attr(fields => sub { [] });

sub unique { shift->constraint('group-unique') }
sub equal  { shift->constraint('group-equal') }

sub constraint {
    my $self = shift;

    my $constraint = MojoX::Validator::ConstraintBuilder->build(@_);

    push @{$self->constraints}, $constraint;

    return $self;
}

sub is_valid {
    my $self = shift;

    # Don't check if some field already has an error
    return 0 if grep {$_->error} @{$self->fields};

    # Get all the values
    my $values = [map { $_->value } @{$self->fields}];

    foreach my $c (@{$self->constraints}) {
        unless ($c->is_valid($values)) {
            $self->error($c->error);
            return 0;
        }
    }

    return 1;
}

1;
