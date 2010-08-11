#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 14;

use MojoX::Validator;

my $validator = MojoX::Validator->new;

$validator->field('password')->required(1);
$validator->field('confirm_password')->required(1);

$validator->group('passwords' => [qw/password confirm_password/])->equal;

ok(!$validator->validate({}));
is_deeply($validator->errors,
    {password => 'REQUIRED', confirm_password => 'REQUIRED'});

ok(!$validator->validate({password => 'foo'}));
is_deeply($validator->errors, {confirm_password => 'REQUIRED'});

ok(!$validator->validate({password => 'foo', confirm_password => 'bar'}));
is_deeply($validator->errors, {passwords => 'EQUAL_CONSTRAINT_FAILED'});

ok($validator->validate({password => 'foo', confirm_password => 'foo'}));
is_deeply($validator->errors, {});

$validator = MojoX::Validator->new;
$validator->field([qw/foo bar/]);
$validator->group('all_or_none' => [qw/foo bar/])->equal;
ok($validator->validate({}));
ok(!$validator->validate({foo => 1}));
is_deeply($validator->errors, {all_or_none => 'EQUAL_CONSTRAINT_FAILED'});
ok(!$validator->validate({bar => 1}));
is_deeply($validator->errors, {all_or_none => 'EQUAL_CONSTRAINT_FAILED'});
ok($validator->validate({foo => 1, bar => 1}));
