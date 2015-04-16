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

sub _build_rest_client {
    my $self = shift;

    my $client = REST::Client->new({
        host => 'http://api.nal.usda.gov',
        timeout => 10
    });
    $client->addHeader('X-Api-Key', $self->api_key);

    return $client;
}

no Moose::Role;

1;
