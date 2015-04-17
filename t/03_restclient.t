#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 7;
use Test::MockModule;
use MooseX::Test::Role;

BEGIN {
    use_ok( 'USDA::NutrientDB::Implementation::REST::HasRESTClient' );
}

requires_ok(
    'USDA::NutrientDB::Implementation::REST::HasRESTClient',
    'api_key'
);

my $consumer = consuming_object(
    'USDA::NutrientDB::Implementation::REST::HasRESTClient'
);

can_ok( $consumer, 'rest_client' );
can_ok( $consumer, 'invalid_key' );
isa_ok( $consumer->rest_client, 'REST::Client' );

my $mock_client = Test::MockModule->new('REST::Client');
$mock_client->mock(GET => undef);
$mock_client->mock(responseCode => sub { return '403' });

ok( $consumer->invalid_key );

$mock_client->mock(responseCode => sub { return '200' });

ok( ! $consumer->invalid_key );
