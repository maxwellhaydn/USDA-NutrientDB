#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 2;
use MooseX::Test::Role;

use USDA::NutrientDB::Implementation::REST::HasRESTClient;

# Test the USDA::NutrientDB::Implementation::REST::HasRESTClient role
my $consumer = consuming_object(
    'USDA::NutrientDB::Implementation::REST::HasRESTClient'
);

ok( my $rest_client = $consumer->rest_client );
ok( $rest_client->isa('REST::Client') );
