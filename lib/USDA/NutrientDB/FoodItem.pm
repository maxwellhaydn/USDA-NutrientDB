package USDA::NutrientDB::FoodItem;
# ABSTRACT: a food item from the USDA National Nutrient Database

use namespace::autoclean;

use Moose;

has 'ndbno' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'food_group' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

__PACKAGE__->meta->make_immutable;
