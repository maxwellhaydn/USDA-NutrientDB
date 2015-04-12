#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 7;
use Test::Exception;

BEGIN {
    use_ok( 'USDA::NutrientDB' );
}

my ($valid_key, $invalid_key) = qw(foo bar);
dies_ok { USDA::NutrientDB->create('REST', api_key => $invalid_key) } 
        'Dies on invalid API key';
ok( my $ndb = USDA::NutrientDB->create('REST', api_key => $valid_key) );
ok( $ndb->isa('USDA::NutrientDB::Implementation::REST'),
    'Passing api_key creates USDA::NutrientDB::Implementation::REST object' );
is( $ndb->api_key, $valid_key );

ok( my ($item) = $ndb->search('cheddar') );
ok( $item->isa('USDA::NutrientDB::FoodItem') ); 
#is( $item->name, 'Cheese, cheddar' );
