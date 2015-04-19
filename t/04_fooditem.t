#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 10;

BEGIN {
    use_ok( 'USDA::NutrientDB::FoodItem' );
}

my $item = new_ok(
    'USDA::NutrientDB::FoodItem',
    [ ndbno => '01009', name => 'Cheese, cheddar', food_group => 'Dairy and Egg
Products' ]
);

can_ok( $item, 'energy' );
can_ok( $item, 'kcal' );
can_ok( $item, 'protein' );
can_ok( $item, 'fat' );
can_ok( $item, 'carbohydrate' );
can_ok( $item, 'fiber' );
can_ok( $item, 'sugar' );
can_ok( $item, 'water' );
