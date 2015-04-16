#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 5;
use Test::MockModule;
use MooseX::Test::Role;

use USDA::NutrientDB::Implementation::REST::HasRESTClient;

requires_ok(
    'USDA::NutrientDB::Implementation::REST::HasRESTClient',
    'api_key'
);

my $consumer = consuming_object(
    'USDA::NutrientDB::Implementation::REST::HasRESTClient'
);

ok( my $client = $consumer->rest_client );
ok( $client->isa('REST::Client') );

# Mock REST::Client so we can test the API key without making an actual request
my $mock = Test::MockModule->new('REST::Client');
$mock->mock(GET => undef);
$mock->mock(responseCode => sub { return '403' });

ok( $consumer->invalid_key );

$mock->mock(responseCode => sub { return '200' });

ok( ! $consumer->invalid_key );
