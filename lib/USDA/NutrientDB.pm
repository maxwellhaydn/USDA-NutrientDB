package USDA::NutrientDB;
# ABSTRACT: query the USDA National Nutrient Database

=head1 SYNOPSIS

    use USDA::NutrientDB;

    my $ndb = USDA::NutrientDB->create('REST', api_key => 'foo');
    my $search = $ndb->search('cheddar');

    while (my $item = $search->next) {
        say $item->kcal;
    }

=head1 DESCRIPTION

This module provides an interface for querying the USDA National Nutrient
Database. It can be accessed via the public REST API (requires a free API key)
or a local copy of the database.

=head1 METHODS

=head2 C<create('REST', api_key => $key)>

Returns a connection to the public REST API, or undef if C<$key> is not a valid
API key.

=head2 C<search($keyword)>

Searches the database for food items that contain C<$keyword> in the food
description, scientific name, or commercial name. In scalar context, returns an
iterator that can be used to fetch the next L<USDA::NutrientDB::FoodItem> from
the result set, e.g.

    my $search = $ndb->search('cheddar');

    while (my $item = $search->next) {
        ...
    }

In list context, returns a list of all matching L<USDA::NutrientDB::FoodItem>s.
For performance reasons, you should generally use the iterator instead.

=head1 SEE ALSO

=over 4

=item *

L<USDA National Nutrient Database homepage|http://ndb.nal.usda.gov/>

=back

=cut

use namespace::autoclean;

use MooseX::AbstractFactory;

implementation_does [ 'USDA::NutrientDB::Implementation::Requires' ];
implementation_class_via sub { 'USDA::NutrientDB::Implementation::' . shift };

__PACKAGE__->meta->make_immutable;
