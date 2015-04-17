package USDA::NutrientDB::Implementation::REST::Results;
# ABSTRACT: an iterator to search results from the USDA Nutrient Database

use namespace::autoclean;

use Moose;

use USDA::NutrientDB::FoodItem;

has 'api_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'keyword' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

with 'USDA::NutrientDB::Implementation::REST::HasRESTClient';

sub next {
    return USDA::NutrientDB::FoodItem->new(
        food_group => 'foo',
        name       => 'bar',
        ndbno      => '123456789'
    );
}

__PACKAGE__->meta->make_immutable;
