package MojoX::Validator;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Validator::Field;
use MojoX::Validator::Group;
use MojoX::Validator::Condition;

__PACKAGE__->attr('fields'     => sub { {} });
__PACKAGE__->attr('bulk');
__PACKAGE__->attr('groups'     => sub { [] });
__PACKAGE__->attr('conditions' => sub { [] });
__PACKAGE__->attr(has_errors   => 0);
__PACKAGE__->attr(trim         => 1);

sub field {
    my $self = shift;

    return $self->{fields}->{$_[0]}
      if ref($_[0]) ne 'ARRAY' && $self->{fields}->{$_[0]};

    my $names = shift;
    $names = [$names] unless ref($names) eq 'ARRAY';

    foreach my $name (@$names) {
        my $field = MojoX::Validator::Field->new(name => $name);

        $self->fields->{$name} = $field;
    }

    $self->bulk($names);

    return $self;
}

sub _each {
    my $self   = shift;
    my $method = shift;

    foreach my $name (@{$self->bulk}) {
        $self->field($name)->$method(@_);
    }


    return $self;
}

sub required { shift->_each(required => @_) }
sub length   { shift->_each(length   => @_) }
sub regexp   { shift->_each(regexp   => @_) }
sub email    { shift->_each(email    => @_) }
sub callback { shift->_each(callback => @_) }

sub when {
    my $self = shift;

    my $cond = MojoX::Validator::Condition->new->when(@_);

    push @{$self->conditions}, $cond;

    return $cond;
}

sub group {
    my $self   = shift;
    my $name   = shift;
    my $fields = shift;

    $fields = [map { $self->fields->{$_} } @$fields];

    my $group =
      MojoX::Validator::Group->new(name => $name, fields => $fields);
    push @{$self->groups}, $group;

    return $group;
}

sub condition {
    my $self = shift;

    my $cond = MojoX::Validator::Condition->new;
    push @{$self->conditions}, $cond;

    return $cond;
}

sub errors {
    my ($self) = @_;

    my $errors = {};

    # Field errors
    foreach my $field (values %{$self->fields}) {
        $errors->{$field->name} = $field->error if $field->error;
    }

    # Group errors
    foreach my $group (@{$self->groups}) {
        $errors->{$group->name} = $group->error if $group->error;
    }

    return $errors;
}

sub clear_errors {
    my ($self) = @_;

    # Clear field errors
    foreach my $field (values %{$self->fields}) {
        $field->error('');
    }

    # Clear group errors
    foreach my $group (@{$self->groups}) {
        $group->error('');
    }

    $self->has_errors(0);
}

sub validate {
    my ($self) = shift;
    my $params = shift;

    $self->clear_errors;

    $self->populate_fields($params);

    while (1) {
        $self->validate_fields;
        $self->validate_groups;

        my @conditions = grep {!$_->matched && $_->match($self->fields)} @{$self->conditions};
        last unless @conditions;

        foreach my $cond (@conditions) {
            $cond->then->($self);
        }
    }

    return $self->has_errors ? 0 : 1;
}

sub populate_fields {
    my $self = shift;
    my $params = shift;

    foreach my $field (values %{$self->fields}) {
        $field->clear_value;

        $field->value($params->{$field->name});
    }
}

sub validate_fields {
    my $self = shift;
    my $params = shift;

    foreach my $field (values %{$self->fields}) {
        $self->has_errors(1) unless $field->is_valid;
    }
}

sub validate_groups {
    my $self = shift;

    foreach my $group (@{$self->groups}) {
        $self->has_errors(1) unless $group->is_valid;
    }
}

sub values {
    my $self = shift;

    my $values = {};

    foreach my $field (values %{$self->fields}) {
        $values->{$field->name} = $field->value if defined $field->value;
    }

    return $values;
}

1;
