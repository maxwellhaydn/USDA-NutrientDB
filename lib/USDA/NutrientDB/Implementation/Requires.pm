package USDA::NutrientDB::Implementation::Requires;
# ABSTRACT: roles that an implementation of USDB::NutrientDB must implement

use namespace::autoclean;

use Moose::Role;

requires 'search';

no Moose::Role;

1;
