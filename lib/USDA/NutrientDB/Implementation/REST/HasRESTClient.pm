package USDA::NutrientDB::Implementation::REST::HasRESTClient;
# ABSTRACT: provides a REST::Client ready to connect to USDA Nutrient Database

use namespace::autoclean;

use Moose::Role;

use REST::Client;

requires 'api_key';

has 'rest_client' => (
    is       => 'ro',
    isa      => 'REST::Client',
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_rest_client'
);

sub invalid_key {
    my $self = shift;

    # URL to fetch the food report for cheddar cheese. Since REST is stateless,
    # the only way we can verify the API key is to send a request and check
    # that it was successful.
    my $query_string = REST::Client::buildQuery(
        ndbno  => 11987,
        type   => 'b',
    );
    my $url = '/usda/ndb/reports/' . $query_string;

    $self->rest_client->GET($url);

    return $self->rest_client->responseCode eq '403';
}

sub _build_rest_client {
    my $self = shift;

    my $client = REST::Client->new({
        host => 'http://api.nal.usda.gov',
        timeout => 10
    });
    $client->addHeader('X-Api-Key', $self->api_key);
    $client->addHeader('Content-Type', 'application/json');

    return $client;
}

no Moose::Role;

1;
