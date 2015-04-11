#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 6;

BEGIN {
    use_ok( 'USDA::NutrientDB' );
}

my $api_key = 'foo';
ok( my $ndb = USDA::NutrientDB->create('REST', api_key => $api_key) );
ok( $ndb->isa('USDA::NutrientDB::Implementation::REST'),
    'Passing api_key creates USDA::NutrientDB::Implementation::REST object' );
is( $ndb->api_key, $api_key );

ok( my ($item) = $ndb->search('cheddar') );
ok( $item->isa('USDA::NutrientDB::FoodItem') ); 
#is( $item->name, 'Cheese, cheddar' );
