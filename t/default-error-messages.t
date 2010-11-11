#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;

use_ok('MojoX::Validator::Field');

# length min - max
my $field = MojoX::Validator::Field->new(name => 'foo');
$field->length([3, 20]);

$field->value('ab');
ok(!$field->is_valid);
is($field->error, 'Field can have between 3 and 20 characters, you have entered 2 characters.');

# length
$field = MojoX::Validator::Field->new(name => 'foo');
$field->length([3]);

$field->value('abcde');
ok(!$field->is_valid);
is($field->error, 'Field must have length of 3 characters, you have entered 5 characters.');

