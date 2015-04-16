#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More tests => 2;
use Test::Exception;
use Test::MockModule;

BEGIN {
    use_ok( 'USDA::NutrientDB::Implementation::REST::Results' );
}

# Mock REST::Client so we don't have to make actual requests
#my $mock_client = Test::MockModule->new('REST::Client');
#$mock_client->mock(GET => undef);
#$mock_client->mock(responseCode => sub { return '403' });

ok( my $results =
        USDA::NutrientDB::Implementation::REST::Results->new );
