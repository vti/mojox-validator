#!/usr/bin/env perl

package CustomConstraint;
use base 'MojoX::Validator::Constraint::In';

package main;

use strict;
use warnings;

use Test::More tests => 4;

use MojoX::Validator::ConstraintBuilder;

my $constraint = MojoX::Validator::ConstraintBuilder->build('in');
ok($constraint);
ok($constraint->isa('MojoX::Validator::Constraint::In'));

$constraint = MojoX::Validator::ConstraintBuilder->build('CustomConstraint');
ok($constraint);
ok($constraint->isa('CustomConstraint'));
