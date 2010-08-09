package MojoX::Validator::Constraint;

use strict;
use warnings;

use base 'Mojo::Base';

__PACKAGE__->attr('error' => 'Invalid input');
__PACKAGE__->attr('args');

sub is_valid {0}

1;
