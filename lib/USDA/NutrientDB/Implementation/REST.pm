package USDA::NutrientDB::Implementation::REST;
# ABSTRACT: query the USDA National Nutrient Database via the REST API

=head1 SYNOPSIS

    use USDA::NutrientDB;

    # Creates a USDA::NutrientDB::Implementation::REST object
    my $ndb = USDA::NutrientDB->create('REST', api_key => 'foo');

=head1 DESCRIPTION

This module provides an interface for querying the USDA National Nutrient
Database via the public REST API. You shouldn't use this module directly;
instead, use the L<USDA::NutrientDB> interface.

=head1 METHODS

=head2 C<new(api_key => $key)>

Returns a connection to the public REST API, or undef if C<$key> is not a valid
API key.

=head2 C<search($string)>

Searches the database for food items that contain C<$string> in the food
description, scientific name, or commercial name. In list context, returns a
list of L<USDA::NutrientDB::FoodItem> objects; in scalar context, returns only
the first match.

=cut

use namespace::autoclean;

use Moose;

use USDA::NutrientDB::FoodItem;

has 'api_key' => (
    is => 'rw',
    isa => 'Str'
);

sub search {
    return USDA::NutrientDB::FoodItem->new;
}

__PACKAGE__->meta->make_immutable;
