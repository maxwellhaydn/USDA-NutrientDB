package USDA::NutrientDB::Implementation::REST::Results;
# ABSTRACT: an iterator to search results from the USDA Nutrient Database

use namespace::autoclean;

use Moose;

use JSON qw(decode_json);
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
    isa      => 'ArrayRef',
    init_arg => undef,
    lazy     => 1,
    builder  => '_get_search_data'
);

has '_cache' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    init_arg => undef
);

with 'USDA::NutrientDB::Implementation::REST::HasRESTClient';

sub next {
    my $self = shift;

    # Return next cached FoodItem, if there is one
    return shift @{ $self->_cache } if $self->_cache;

    # Otherwise, fetch nutrient details for next search result and re-populate
    # the cache
    return unless $self->_search_data;
    my $next_match = shift @{ $self->_search_data };

    my $nutrient_data = $self->_get_nutrient_data($next_match->{ndbno});

    # Mapping of nutrient names as used in the database to FoodItem attribute
    # names
    my %attribute = (
        Energy                        => 'energy',
        Protein                       => 'protein',
        'Total lipid (fat)'           => 'fat',
        'Carbohydrate, by difference' => 'carbohydrate',
        'Fiber, total dietary'        => 'fiber',
        'Sugars, total'               => 'sugar',
        Water                         => 'water'
    );
    
    # Generate a new FoodItem for each unique measure (e.g. "cup, diced", "oz",
    # "cubic inch") returned in the detailed food report and set the
    # corresponding nutrient values
    my %items;
    foreach my $nutrient (@$nutrient_data) {

        foreach my $measure (@{ $nutrient->{measures} }) {

            my $unit = $measure->{label};

            # Create one and only one FoodItem object for each unit of measure
            if (! exists $items{$unit}) {
                $items{$unit} = USDA::NutrientDB::FoodItem->new(
                    ndbno      => $next_match->{ndbno},
                    name       => $next_match->{name},
                    food_group => $next_match->{group},
                    quantity   => $measure->{qty},
                    units      => $unit,
                    grams      => $measure->{eqv}
                );
            }

            # Set the amount of this nutrient, e.g. 48.97 g of water,
            # 536.0 kcal of energy
            my $item = $items{$unit};
            my $attribute_name = $attribute{ $nutrient->{name} };
            next unless defined $attribute_name;

            my $setter = $item->meta
                              ->find_attribute_by_name($attribute_name)
                              ->get_write_method_ref;
            $setter->($item, $measure->{value});
        }
    }

    # Re-populate the cache and return the first FoodItem in the list
    $self->_cache([ values %items ]);

    return shift @{ $self->_cache };
}

# Submit a search request to the REST API. This returns a list of matching food
# items' names, ndbno values, and food groups, but no other details.
sub _get_search_data {
    my $self = shift;

    my $query_string = $self->_rest_client->buildQuery(q => $self->keyword);
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

    my $query_string = $self->_rest_client->buildQuery(
        ndbno => $ndbno,
        type  => 'b'      # Basic report
    );
    my $url = '/usda/ndb/reports/' . $query_string;

    $self->_rest_client->GET($url);

    # TODO: Handle errors

    if ($self->_rest_client->responseCode eq '200') {
        my $results = decode_json($self->_rest_client->responseContent);
        return $results->{report}{food}{nutrients};
    }

    return;
}

__PACKAGE__->meta->make_immutable;
