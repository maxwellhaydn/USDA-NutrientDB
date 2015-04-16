package USDA::NutrientDB::Implementation::REST::Results;
# ABSTRACT: an iterator to search results from the USDA Nutrient Database

use namespace::autoclean;

use Moose;

#has 'keyword' => (
#    is       => 'ro',
#    isa      => 'Str',
#    required => 1
#);
#
#has 'rest_client' => (
#    is       => 'ro',
#    isa      => 'REST::Client',
#    required => 1
#);
#
#has '_initial_results' => (
#    is       => 'ro',
#    isa      => 'Hashref',
#    lazy     => 1,
#    builder  => '_results_builder',
#    init_arg => undef
#);
#
#sub next {
#    my $self = shift;
#    my $next = shift $self->_initial_results;
#
#    return undef if ! defined $next;
#
#    # Fetch details for next item
#    my $client = $self->rest_client;
#    $client->GET($url);
#    
#}
#
## Fetch initial set of results, which only includes ndbno, name, and food group
## for each matching item.
#sub _results_builder {
#    my $self = shift;
#    my $client = $self->rest_client;
#
#    my $url = '???' . $self->keyword;
#
#    # TODO: Is it safe to pass around references to the same REST::Client?
#    $client->GET($url);
#
#    # TODO: Check for failure
#
#    return $client->responseContent;
#}

__PACKAGE__->meta->make_immutable;
