package USDA::NutrientDB::FoodItem;
# ABSTRACT: a food item from the USDA National Nutrient Database

use namespace::autoclean;

use Moose;

has 'name' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

__PACKAGE__->meta->make_immutable;
