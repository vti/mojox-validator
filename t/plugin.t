#!/usr/bin/env perl

package Custom;

use base 'MojoX::Validator';

sub new {
    my $self = shift->SUPER::new(@_);

    $self->field('foo')->required(1)->length(3, 10);

    return $self;
}

package Decamelized;
use base 'Custom';

package WrongIsa;

sub new { }

package Broken;

use base 'MojoX::Validator';

sub new {
    die 'broken!';
}

package main;

use strict;
use warnings;

use Test::More;

plan skip_all => 'working sockets required for this test!'
  unless Mojo::IOLoop->new->generate_port;
plan tests => 31;

use Mojolicious::Lite;

plugin 'validator';

post '/' => sub {
    my $self = shift;

    my $validator = $self->create_validator;

    $validator->field('foo')->required(1)->length(3, 10);

    if ($self->validate($validator)) {
        return $self->render('ok');
    }
} => 'form';

post '/custom' => sub {
    my $self = shift;

    my $validator = $self->create_validator('Custom');

    if ($self->validate($validator)) {
        return $self->render('ok');
    }

    $self->render('form');
} => 'custom';

post '/decamelized' => sub {
    my $self = shift;

    my $validator = $self->create_validator('decamelized');

    if ($self->validate($validator)) {
        return $self->render('ok');
    }

    $self->render('form');
} => 'decamelized';

post '/broken' => sub {
    my $self = shift;

    $self->create_validator('Broken');
} => 'broken';

post '/wrong-isa' => sub {
    my $self = shift;

    $self->create_validator('WrongIsa');
} => 'wrong-isa';

use Test::Mojo;

my $t = Test::Mojo->new;

#$ENV{MOJO_LOG_LEVEL} = 'debug';

for my $path ('', 'custom', 'decamelized') {
    $t->post_form_ok("/$path" => {})->status_is(200)
      ->content_like(qr/required/i);
    $t->post_form_ok("/$path" => {foo => '12345678901'})->status_is(200)
      ->content_like(qr/length/i);
    $t->post_form_ok("/$path" => {foo => '123'})->status_is(200)
      ->content_like(qr/ok/i);
}

$t->post_form_ok('/wrong-isa' => {})->status_is(500);
$t->post_form_ok('/broken'    => {})->status_is(500);

__DATA__

@@ form.html.ep
%= form_for 'form', method => 'post' => begin
    <%= input_tag 'foo' %>
    <%= validator_error 'foo' %>
%= end

@@ ok.html.ep
OK
