#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 10;

use MojoX::Validator;

# Unknown params, but no errors without explicit => 1
ok(my $validator = MojoX::Validator->new);
ok($validator->validate({firstname => 'bar'}));
ok!($validator->errors->{firstname});
ok!($validator->has_errors);
ok($validator->has_unknown_params);

# Unknown params and errors with explicit => 1
ok($validator = MojoX::Validator->new(explicit => 1));
ok(!$validator->validate({firstname => 'bar'}));
is($validator->errors->{firstname}, 'NOT_SPECIFIED');
is($validator->values->{firstname} => 'bar');
ok($validator->has_unknown_params);
