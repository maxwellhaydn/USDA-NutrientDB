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

has '_search_data' => (
    is       => 'ro',
    isa      => 'Arrayref',
    init_arg => undef,
    lazy     => 1,
    builder  => '_get_search_data'
);

has '_cache' => (
    is       => 'ro',
    isa      => 'Arrayref',
    init_arg => undef
);

with 'USDA::NutrientDB::Implementation::REST::HasRESTClient';

sub next {
    my $self = shift;

    # Return next cached FoodItem, if there is one
    return shift @{ $self->_cache } if $self->_cache;

    # Otherwise, fetch nutrient details for next search result and re-populate
    # the cache
    my $next_match = shift $self->_search_data;

    my @nutrient_data = $self->_get_nutrient_data($next_match->{ndbno});

    # Generate a new FoodItem for each unique measure (e.g. "cup, diced", "oz",
    # "cubic inch") returned in the detailed food report
    my %items;
    foreach my $nutrient (@nutrient_data) {
        my $nutrient_object = USDA::NutrientDB::Nutrient->new(
            name => $nutrient->{name},
            unit => $nutrient->{unit}
        );

        foreach my $measure ($nutrient->{measures}) {

            # Amount of the nutrient, e.g. 48.97 g of water, 536.0 kcal of
            # energy
            $nutrient_object->quantity($measure->{value});

            if (exists $items{$measure}) {
                $items{$measure}->addNutrient($nutrient_object);
            }
            else {
                $items{$measure} = USDA::NutrientDB::FoodItem->new(
                    ndbno      => $next_match->{ndbno},
                    name       => $next_match->{name},
                    food_group => $next_match->{fg},
                    quantity   => $measure->{qty},
                    unit       => $measure->{label},
                    grams      => $measure->{eqv},
                    nutrients  => [ $nutrient_object ]
                );
            }
        }
    }

    # Re-populate the cache and return the first FoodItem in the list
    $self->_cache(values %items);

    return shift $self->_cache;
}

# Submit a search request to the REST API. This returns a list of matching food
# items' names, ndbno values, and food groups, but no other details.
sub _get_search_data {
    my $self = shift;

    my $query_string = REST::Client::buildQuery(q => $self->keyword);
    my $url = '/usda/ndb/search/' . $query_string;

    $self->_rest_client->GET($url);

    # TODO: Handle errors

    if ($self->_rest_client->responseCode eq '200') {
        my $results = decode_json($self->_rest_client->responseContent);
        return $results->{list}{item};
    }

    return;
}

# Submit a request for a detailed food report for the given item and return the
# associated nutrient data.
sub _get_nutrient_data {
    my $self = shift;
    my $ndbno = shift;

    my $query_string = REST::Client::buildQuery(
        ndbno => $ndbno,
        type  => 'b'      # Basic report
    );
    my $url = '/usda/ndb/search/' . $query_string;

    $self->_rest_client->GET($url);

    # TODO: Handle errors

    if ($self->_rest_client->responseCode eq '200') {
        my $results = decode_json($self->_rest_client->responseContent);
        return $results->{list}{item};
    }

    return;
}

__PACKAGE__->meta->make_immutable;
