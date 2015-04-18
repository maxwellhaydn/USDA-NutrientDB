package USDA::NutrientDB::Implementation::REST::Results;
# ABSTRACT: an iterator to search results from the USDA Nutrient Database

use namespace::autoclean;

use Moose;

use USDA::NutrientDB::FoodItem;

has 'api_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'keyword' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has '_matching_items' => (
    is       => 'ro',
    isa      => 'Arrayref',
    init_arg => undef,
    lazy     => 1,
    builder  => '_get_matching_items'
);

has '_results' => (
    is       => 'ro',
    isa      => 'Arrayref',
    init_arg => undef
);

with 'USDA::NutrientDB::Implementation::REST::HasRESTClient';

sub next {
    my $self = shift;

    # Return next cached FoodItem, if there is one
#    return shift $self->_results if @{ $self->_results };
#
#    # Otherwise, fetch nutrient details for next search result and re-populate
#    # the cache
#    my $next = shift $self->_matching_items;
#
#    my @nutrients = $self->_get_nutrients($next->ndbno);
#
#    # Get unique measures (e.g. "cup, diced", "oz", "cubic inch") for this item
#    my %measures;
#    #foreach my $nutrient (@nutrients) {
#    #    @measures{  } = map { $_->{label} } @{ $nutrient->{measures} };
#
#    foreach my $nutrient (@nutrients) {
#        my $item = USDA::NutrientDB::FoodItem->new(
#            ndbno => $next->ndbo,
#            name  => $next->name,
#            food_group => $next->food_group,
#            #quantity => $nutrient->
#        );
#    }

    return USDA::NutrientDB::FoodItem->new(
        food_group => 'foo',
        name       => 'bar',
        ndbno      => '123456789'
    );
}

# Submit a search request to the REST API. This returns a list of matching food
# items' names, ndbno values, and food groups, but no other details.
sub _get_matching_items {
    my $self = shift;

    my $query_string = REST::Client::buildQuery(q => $self->keyword);
    my $url = '/usda/ndb/search/' . $query_string;

    $self->rest_client->GET($url);

    # TODO: Handle errors

    if ($self->rest_client->responseCode eq '200') {
        my $results = decode_json($self->rest_client->responseContent);
        return $results->{list}{item};
    }

    return;
}

# Submit a request for a detailed food report for the given item and return a
# list of nutrients.
sub _get_nutrients {
    my $self = shift;
    my $ndbno = shift;

    my $query_string = REST::Client::buildQuery(
        ndbno => $ndbno,
        type  => 'b'      # Basic report
    );
    my $url = '/usda/ndb/search/' . $query_string;

    $self->rest_client->GET($url);

    # TODO: Handle errors

    if ($self->rest_client->responseCode eq '200') {
        my $results = decode_json($self->rest_client->responseContent);
        return $results->{list}{item};
    }

    return;
}

__PACKAGE__->meta->make_immutable;
