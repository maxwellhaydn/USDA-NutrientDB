#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 8;
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
dies_ok { USDA::NutrientDB->create('REST', api_key => $invalid_key) } 
        'Dies on invalid API key';

$mock_client->mock(responseCode => sub { return '200' });
ok( my $ndb = USDA::NutrientDB->create('REST', api_key => $valid_key),
    'create method returns something for a valid key' );
ok( $ndb->isa('USDA::NutrientDB::Implementation::REST'),
    'Passing api_key creates USDA::NutrientDB::Implementation::REST object' );
is( $ndb->api_key, $valid_key );

ok( my ($item) = $ndb->search('cheddar'),
    'search for "cheddar" returns something' );
ok( $item->isa('USDA::NutrientDB::FoodItem'),
    'search method returns a FoodItem' ); 
is( $item->name, 'Cheese, cheddar' );
