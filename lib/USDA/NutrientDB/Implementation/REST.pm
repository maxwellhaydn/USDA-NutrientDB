package USDA::NutrientDB::Implementation::REST;
# ABSTRACT: query the USDA National Nutrient Database via the REST API

=head1 SYNOPSIS

    use USDA::NutrientDB;

    # Creates a USDA::NutrientDB::Implementation::REST object
    my $ndb = USDA::NutrientDB->create('REST', api_key => 'foo');
    $ndb->search('cheddar');

    while (my $item = $ndb->next) {
        say $item->kcal;
    }

=head1 DESCRIPTION

This module provides an interface for querying the USDA National Nutrient
Database via the public REST API. You shouldn't use this module directly;
instead, use the L<USDA::NutrientDB> interface.

=head1 METHODS

=head2 C<new(api_key => $key)>

Returns a connection to the public REST API. Croaks if C<$key> is not a valid
API key.

=head2 C<search($keyword)>

Searches the database for food items that contain C<$keyword> in the food
description, scientific name, or commercial name. In scalar context, returns an
iterator that can be used to fetch the next L<USDA::NutrientDB::FoodItem> from
the result set, e.g.

    my $results = $ndb->search('cheddar');

    while (my $item = $results->next) {
        ...
    }

In list context, returns a list of all matching L<USDA::NutrientDB::FoodItem>s.
For performance reasons, you should generally use the iterator instead.

=cut

use namespace::autoclean;

use Moose;

use Carp;
use USDA::NutrientDB::Implementation::REST::Results;

has 'api_key' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

with 'USDA::NutrientDB::Implementation::REST::HasRESTClient';

sub BUILD {
    my $self = shift;

    croak 'Invalid API key: "' . $self->api_key . '"' if $self->invalid_key;

    # TODO: croak on 404, 500, etc?
}

sub search {
    my $self = shift;
    my $keyword = shift;

    return USDA::NutrientDB::Implementation::REST::Results->new(
        api_key => $self->api_key,
        keyword => $keyword
    );
}

__PACKAGE__->meta->make_immutable;
