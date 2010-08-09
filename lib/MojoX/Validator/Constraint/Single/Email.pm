package MojoX::Validator::Constraint::Single::Email;

use strict;
use warnings;

use base 'MojoX::Validator::Constraint';

use constant NAME_MAX_LENGTH   => 64;
use constant DOMAIN_MAX_LENGTH => 255;

sub is_valid {
    my ($self, $value) = @_;

    return unless length $value <= NAME_MAX_LENGTH + 1 + DOMAIN_MAX_LENGTH;

    my ($name, $domain) = split /@/ => $value;
    return 0 unless defined $name && defined $domain;
    return 0 if $name eq '' || $domain eq '';

    return unless length $name <= NAME_MAX_LENGTH;
    return unless length $domain <= DOMAIN_MAX_LENGTH;

    my ($subdomain, $root) = split /\./ => $domain;
    return unless $subdomain && $root;

    return 1;
}

1;
