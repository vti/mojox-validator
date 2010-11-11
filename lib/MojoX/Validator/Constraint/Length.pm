package MojoX::Validator::Constraint::Length;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

sub is_valid {
    my ($self, $value) = @_;

    my $len = length $value;

    my $args = $self->args;
    my ($min, $max) = ref $args eq 'ARRAY' ? @{$args} : ($args);

    return $len eq $min ? 1 : (0, [$min, $max, $len]) unless $max;

    return $len >= $min && $len <= $max ? 1 : (0, [$min, $max, $len]);
}

sub message {
    my $self = shift;

    my $args = $self->args;
    my ($min, $max) = ref $args eq 'ARRAY' ? @{$args} : ($args);

    if ($max) {
        'Field can have between %s and %s characters, you have entered %s characters.'
    }
    else {
        'Field must have length of %1$s characters, you have entered %3$s characters.'
    }
}

1;
__END__

=head1 NAME

MojoX::Validator::Constraint::Length - Length constraint

=head1 SYNOPSIS

    $validator->field('name')->length(10);
    $validator->field('name')->length(1, 40);

=head1 DESCRIPTION

Checks whether the value is exactly C<n> characters length, or is between
C<n, m> values.

=head1 METHODS

=head2 C<is_valid>

Validates the constraint.

=head1 CUSTOM ERROR MESSAGES

Provides values for use in custom error messages in the following order:

min value, max value, actual length

    my $validator =
      MojoX::Validator->new(
        messages => {
          LENGTH_CONSTRAINT_FAILED => 'Field can have between %s and %s
            characters, you entered %s characters.'
        }
    );

=head1 SEE ALSO

L<MojoX::Validator>, L<MojoX::Constraint>

=cut
