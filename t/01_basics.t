#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 6;
use Test::Exception;
use Test::MockModule;

BEGIN {
    use_ok( 'USDA::NutrientDB' );
}

# Mock REST::Client so we don't have to make actual requests
my $mock_client = Test::MockModule->new('REST::Client');
$mock_client->mock(GET => undef);
$mock_client->mock(responseCode => sub { return '403' });

my ($valid_key, $invalid_key) = qw(foo bar);

throws_ok {
    USDA::NutrientDB->create('REST', api_key => $invalid_key)
} qr/invalid api key/i, 'Dies on invalid API key';

# TODO: Check for 404

$mock_client->mock(responseCode => sub { return '200' });

my $ndb = USDA::NutrientDB->create('REST', api_key => $valid_key);

isa_ok(
    $ndb,
    'USDA::NutrientDB::Implementation::REST'
);

can_ok( $ndb, 'api_key' );
can_ok( $ndb, 'search' );

my $search = $ndb->search('cheddar');

isa_ok(
    $search,
    'USDA::NutrientDB::Implementation::REST::Results',
    'search in scalar context returns an iterator to search results'
);

#my $item = $search->next;
#ok( $item->isa('USDA::NutrientDB::FoodItem'),
#    'next method returns a FoodItem' ); 
#is( $item->ndbno, '01009' );
#is( $item->name, 'Cheese, cheddar' );
#is( $item->food_group, 'Dairy and Egg Products' );
#is( $item->measure, 'cup, diced' );
