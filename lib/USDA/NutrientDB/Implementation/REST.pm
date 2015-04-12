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

use Carp;
use REST::Client;
use USDA::NutrientDB::FoodItem;

has 'api_key' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has '_rest_client' => (
    is       => 'rw',
    isa      => 'REST::Client',
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_rest_client'
);

sub BUILD {
    my $self = shift;

    croak 'Invalid API key: ' . $self->api_key unless $self->_key_is_valid;
}

sub search {
    my $self = shift;
    my $keyword = shift;

    return USDA::NutrientDB::FoodItem->new;
}

sub _key_is_valid {
    my $self = shift;

    # URL to fetch the food report for cheddar cheese. Since REST is stateless,
    # the only way we can verify the API key is to send a request and check
    # that it was successful.
    my $url = '/usda/ndb/reports/?ndbno=11987&type=b&format=fjson';
    my $client = $self->_rest_client;

    $client->GET($url);

    return $client->responseCode eq '200';
}

sub _build_rest_client {
    my $self = shift;

    my $client = REST::Client->new({ host => 'http://api.nal.usda.gov' });
    $client->addHeader('X-Api-Key', $self->api_key);

    return $client;
}

__PACKAGE__->meta->make_immutable;
