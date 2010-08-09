#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;

use MojoX::Validator::Constraint::Single::Length;

my $constraint =
  MojoX::Validator::Constraint::Single::Length->new(args => [3, 5]);

ok($constraint);

is($constraint->is_valid('Hello'), 1);

is($constraint->is_valid('He'), 0);

is($constraint->is_valid('Hello!'), 0);
