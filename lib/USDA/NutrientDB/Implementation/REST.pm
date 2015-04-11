package USDA::NutrientDB::Implementation::REST;
# ABSTRACT: query the USDA National Nutrient Database via the REST API

use namespace::autoclean;

use Moose;

use USDA::NutrientDB::FoodItem;

sub search {
    return USDA::NutrientDB::FoodItem->new;
}

__PACKAGE__->meta->make_immutable;
