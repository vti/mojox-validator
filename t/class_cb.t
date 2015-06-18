#!/usr/bin/env perl

package FooValidator;
use base 'MojoX::Validator';

package BarValidator;
use base 'MojoX::Validator';

#------------------------------------------------------------------------------

package main;

use strict;
use warnings;

use Test::More;
use Test::Exception;

plan skip_all => 'working sockets required for this test!'
  unless Mojo::IOLoop->new->generate_port;
plan tests => 3;

use Mojolicious::Lite;

throws_ok { plugin 'validator' => {class_cb => {}} }
  qr/class_cb must be a CODE ref/i;

plugin 'validator' => {class_cb => sub {'FooValidator'}};

my $validator; # Closure!
get '/foo' => sub {
    my $self = shift;
    $validator = $self->create_validator;
    return $self->render(text => '');
};


get '/bar' => sub {
    my $self = shift;
    $validator = $self->create_validator('BarValidator');
    return $self->render(text => '');
};


use Test::Mojo;
my $t = Test::Mojo->new;
#$ENV{MOJO_LOG_LEVEL} = 'debug';

subtest 'Using class callback' => sub {
    $t->get_ok('/foo')->status_is(200);
    isa_ok($validator, 'FooValidator');
};


subtest 'Using named class' => sub {
    $t->get_ok('/bar')->status_is(200);
    isa_ok($validator, 'BarValidator');
};
