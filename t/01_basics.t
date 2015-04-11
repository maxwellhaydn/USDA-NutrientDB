#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 3;

BEGIN {
    use_ok( 'USDA::NutrientDB' );
}

ok( my $ndb = USDA::NutrientDB->create('REST', api_key => 'foo') );
ok( $ndb->isa('USDA::NutrientDB::Implementation::REST'), 'Passing api_key creates USDA::NutrientDB::Implementation::REST object' );
