package MojoX::Validator::Condition;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Validator::ConstraintBuilder;

__PACKAGE__->attr(matched => 0);
__PACKAGE__->attr(then    => sub { });
__PACKAGE__->attr(bulks   => sub { [] });

sub regexp {shift->constraint('single-regexp' => @_)}
sub length {shift->constraint('single-length' => @_)}

sub when {
    my $self   = shift;
    my $fields = shift;
    $fields = [$fields] unless ref($fields) eq 'ARRAY';

    my $bulk = {fields => $fields, constraints => []};
    push @{$self->bulks}, $bulk;

    return $self;
}

sub constraint {
    my $self = shift;

    my $constraint = MojoX::Validator::ConstraintBuilder->build(@_);

    my $bulk = $self->bulks->[-1];
    push @{$bulk->{constraints}}, $constraint;

    return $self;
}

sub match {
    my $self = shift;
    my $params = shift;

    foreach my $bulk (@{$self->bulks}) {
        foreach my $name (@{$bulk->{fields}}) {
            my $field = $params->{$name};

            # No field
            return 0 unless $field;

            # Field has already an error
            return 0 if $field->error;

            my $values = $field->value;
            $values = [$values] unless ref($values) eq 'ARRAY';

            foreach my $value (@$values) {
                return 0 unless defined($value) && $value ne '';

                foreach my $c (@{$bulk->{constraints}}) {
                    return 0 unless $c->is_valid($value);
                }
            }
        }
    }

    $self->matched(1);

    return 1;
}

1;
