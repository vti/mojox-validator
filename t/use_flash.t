#!/usr/bin/env perl


use strict;
use warnings;

use Test::More;

plan skip_all => 'working sockets required for this test!'
  unless Mojo::IOLoop->new->generate_port;

use Mojolicious::Lite;

# Using flash here.  All validation errors will be
# visible in the *next* request, not the current one.
plugin 'validator' => {use_flash => 1};

post '/form' => sub {
    my $self = shift;

    my $validator = $self->create_validator;
    $validator->field('foo')->required(1);

    $self->validate($validator);
    $self->render('form');
};

get '/after' => sub { shift->render };

use Test::Mojo;

#$ENV{MOJO_LOG_LEVEL} = 'debug';

my $t = Test::Mojo->new;

subtest 'POST invalid form' => sub {

    # First request: post invalid form
    $t->post_ok("/form")->status_is(200)
        ->content_is('', 'No error on first request');

    # Second request: get (usually by redirect)
    $t->get_ok("/after")->status_is(200)
        ->content_like(qr/required/i, 'But error appears on second request');

    # Third request: get
    $t->get_ok("/after")->status_is(200)
        ->content_is('', 'To be sure, no error on third request');
};


subtest 'POST valid form' => sub {
    # First request: post valid form
    $t->post_ok("/form" => form => {foo => '12345678901'})->status_is(200)
        ->content_is('', 'No error appears on first request');

    # Second request: get (usually by redirect)
    $t->get_ok("/after")->status_is(200)
        ->content_is('', 'No error on second request either');
};

done_testing;

__DATA__

@@ form.html.ep
<%= validator_error 'foo'=%>

@@ after.html.ep
<%= validator_error 'foo' =%>
