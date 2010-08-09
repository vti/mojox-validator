#!/usr/bin/perl env

use strict;
use warnings;

use Test::More tests => 4;

use MojoX::Validator::Constraint::Single::In;

my $constraint = MojoX::Validator::Constraint::Single::In->new(args => [1, 5, 7]);

ok($constraint);

is($constraint->is_valid(1), 1);

is($constraint->is_valid(7), 1);

is($constraint->is_valid(2), 0);
