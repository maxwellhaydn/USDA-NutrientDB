#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 7;
use Test::Exception;
use Test::MockModule;

BEGIN {
    use_ok( 'USDA::NutrientDB::Implementation::REST::Results' );
}

# Mock REST::Client so we don't have to make actual requests
#my $mock_client = Test::MockModule->new('REST::Client');
#$mock_client->mock(GET => undef);
#$mock_client->mock(responseCode => sub { return '403' });

my $results = new_ok(
    'USDA::NutrientDB::Implementation::REST::Results',
    [ keyword => 'cheddar', api_key => 'foo' ]
);

can_ok( $results, 'api_key' );
can_ok( $results, 'keyword' );
can_ok( $results, 'rest_client' );
can_ok( $results, 'next' );

my $first = $results->next;

isa_ok( $first, 'USDA::NutrientDB::FoodItem' );
