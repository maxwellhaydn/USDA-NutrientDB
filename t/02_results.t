#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More;
use Test::Exception;
use Test::MockModule;

my $ndb;

BEGIN {
    my $api_key = $ENV{USDA_API_KEY} // 'DEMO_KEY';

    eval {
        require USDA::NutrientDB;
        $ndb = USDA::NutrientDB->create('REST', {
            api_key => $api_key
        });
    };

    if ($@) {
        plan skip_all => $@;
        exit 0;
    }
    else {
        plan tests => 8;
    }
}

BEGIN {
    use_ok( 'USDA::NutrientDB::Implementation::REST::Results' );
}

my $results = $ndb->search('cheddar');

can_ok( $results, 'api_key' );
can_ok( $results, 'keyword' );
can_ok( $results, 'next' );

my $first = $results->next;

isa_ok( $first, 'USDA::NutrientDB::FoodItem' );
is( $first->food_group, 'Dairy and Egg Products' );
is( $first->name, 'Cheese, cheddar' );
is( $first->ndbno, '01009' );
