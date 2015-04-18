#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 4;
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

can_ok( $consumer, '_rest_client' );
isa_ok( $consumer->_rest_client, 'REST::Client' );
