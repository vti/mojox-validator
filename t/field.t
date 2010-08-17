#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 35;

use_ok('MojoX::Validator::Field');

my $field = MojoX::Validator::Field->new(name => 'foo');
$field->required(1);
$field->length([3, 20]);
$field->regexp(qr/^\d+$/);

ok(!$field->is_valid);
is($field->error, 'REQUIRED');

$field->value('');
ok(!$field->is_valid);
is($field->error, 'REQUIRED');

$field->value('   ');
ok(!$field->is_valid);
is($field->error, 'REQUIRED');

$field->value('ab');
ok(!$field->is_valid);
is($field->error, 'LENGTH_CONSTRAINT_FAILED');

$field->value('abc');
ok(!$field->is_valid);
is($field->error, 'REGEXP_CONSTRAINT_FAILED');

$field->value(123);
ok($field->is_valid);
ok(!$field->error);

$field = MojoX::Validator::Field->new(name => 'foo');
$field->length([3, 20]);

ok($field->is_valid);
ok(!$field->error);

$field->value('ab');
ok(!$field->is_valid);
is($field->error, 'LENGTH_CONSTRAINT_FAILED');

$field->value('abc');
ok($field->is_valid);
ok(!$field->error);

$field = MojoX::Validator::Field->new(name => 'foo');
$field->length([3, 20]);

$field->value([qw/fo bar/]);
is($field->value, 'fo');
ok(!$field->is_valid);
is($field->error, 'LENGTH_CONSTRAINT_FAILED');

$field->value([qw/foo ba/]);
is($field->value, 'foo');
ok($field->is_valid);
ok(!$field->error);

$field->multiple(1);
$field->value([qw/foo ba/]);
is_deeply($field->value, [qw/foo ba/]);
ok(!$field->is_valid);

$field->value([qw/foo bar/]);
is_deeply($field->value, [qw/foo bar/]);
ok($field->is_valid);

$field = MojoX::Validator::Field->new(name => 'foo');
$field->required(1)->in(0, 1);
ok(!$field->is_defined);
ok($field->is_empty);
ok(!$field->is_valid);

$field->value(0);
ok($field->is_defined);
ok(!$field->is_empty);
ok($field->is_valid);
