package USDA::NutrientDB::Implementation::REST;
# ABSTRACT: query the USDA National Nutrient Database via the REST API

use namespace::autoclean;

use Moose;

sub search {
    return 1;
}

__PACKAGE__->meta->make_immutable;
