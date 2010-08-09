#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 9;

use MojoX::Validator::Constraint::Single::Time;

my $constraint = MojoX::Validator::Constraint::Single::Time->new(args => 1);

ok($constraint);

is($constraint->is_valid('Hello'), 0);
is($constraint->is_valid('33:33'), 0);
is($constraint->is_valid('00:60'), 0);
is($constraint->is_valid('25:00'), 0);

is($constraint->is_valid('00:59'), 1);
is($constraint->is_valid('00:00'), 1);
is($constraint->is_valid('12:12'), 1);
is($constraint->is_valid('23:00'), 1);
