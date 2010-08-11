package MojoX::Validator::Field;

use strict;
use warnings;

use base 'Mojo::Base';

use MojoX::Validator::ConstraintBuilder;

__PACKAGE__->attr('name');
__PACKAGE__->attr(['required', 'multiple'] => 0);
__PACKAGE__->attr('error');
__PACKAGE__->attr('trim' => 1);
__PACKAGE__->attr(constraints => sub { [] });

# Shortcuts
sub callback { shift->constraint('callback' => @_) }
sub email    { shift->constraint('email'    => @_) }
sub in       { shift->constraint('in'       => @_) }
sub length   { shift->constraint('length'   => @_) }
sub regexp   { shift->constraint('regexp'   => @_) }

sub constraint {
    my $self = shift;

    my $constraint = MojoX::Validator::ConstraintBuilder->build(@_);

    push @{$self->constraints}, $constraint;

    return $self;
}

sub value {
    my $self = shift;

    return $self->{value} unless @_;

    my $value = shift;
    return unless defined $value;

    if ($self->multiple) {
        $self->{value} = ref($value) eq 'ARRAY' ? $value : [$value];
    }
    else {
        $self->{value} = ref($value) eq 'ARRAY' ? $value->[0] : $value;
    }

    return $self unless $self->trim;

    foreach (
        ref($self->{value}) eq 'ARRAY' ? @{$self->{value}} : ($self->{value}))
    {
        s/^\s+//;
        s/\s+$//;
    }

    return $self;
}

sub is_valid {
    my ($self) = @_;

    $self->error('');

    $self->error('REQUIRED'), return 0 if $self->required && $self->is_empty;

    return 1 if $self->is_empty;

    foreach my $c (@{$self->constraints}) {
        my @values =
          ref $self->value eq 'ARRAY' ? @{$self->value} : ($self->value);

        foreach my $value (@values) {
            my ($ok, $error) = $c->is_valid($value);

            unless ($ok) {
                $self->error( $error ? $error : $c->error);
                return 0;
            }
        }
    }

    return 1;
}

sub clear_error {
    my $self = shift;

    delete $self->{error};
}

sub clear_value {
    my $self = shift;

    delete $self->{value};
}

sub is_defined {
    my ($self) = @_;

    return defined $self->value ? 1 : 0;
}

sub is_empty {
    my ($self) = @_;

    return 1 unless $self->is_defined;

    return $self->value eq '' ? 1 : 0;
}

1;
__END__

=head1 NAME

MojoX::Validator::Field - Field object

=head1 SYNOPSIS

    $validator->field('foo');
    $validator->field(qw/foo bar/);
    $validator->field([qw/foo bar baz/]);

=head1 DESCRIPTION

Field object. Used internally.

=head1 ATTRIBUTES

=head2 C<error>

    $field->error('Invalid input');
    my $error = $field->error;

Field error.

=head2 C<multiple>

    $field->multiple(1);

Field can have multiple values. Use this when you want to allow array reference
as value.

=head2 C<name>

    $field->name('foo');
    my $name = $field->name;

Field's name.

=head2 C<required>

    $field->required(1);

Whether field is required or not. See L<MojoX::Validator> documentation what is
an empty field.

=head2 C<trim>

    $field->trim(1);

Whether field's value should be trimmed before validation. It is B<ON> by
default.

=head1 METHODS

=head2 C<callback>

Shortcut

    $field->constraint(callback => sub { ... });

=head2 C<clear_error>

    $field->clear_value;

Clears field's error.

=head2 C<clear_value>

    $field->clear_value;

Clears field's value.

=head2 C<constraint>

    $field->constraint(length => [1, 2]);

Adds a new field's constraint.

=head2 C<email>

Shortcut

    $field->constraint(email => @_);

=head2 C<in>

Shortcut

    $field->constraint(in => @_);

=head2 C<is_defined>

    my $defined = $field->is_defined;

Checks whether field's value is defined.

=head2 C<is_empty>

    my $empty = $field->is_empty;

Checks whether field's value is empty.

=head2 C<is_valid>

Checks whether all field's constraints are valid.

=head2 C<length>

Shortcut

    $field->constraint(length => @_);

=head2 C<regexp>

Shortcut

    $field->constraint(regexp => @_);

=head2 C<value>

    my $value = $field->value;
    $field->value('foo')

Set or get field's value.

=head1 SEE ALSO

L<MojoX::Validator>, L<MojoX::Validator::Constraint>

=cut
